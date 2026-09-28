{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    concatMapStringsSep
    ;

  cfg = config.programs.fl-studio;

  flStudioWine = pkgs.writeShellScriptBin "fl-studio-wine" ''
    export WINEPREFIX="${cfg.prefix}"
    export WINEARCH="win64"
    exec ${cfg.package}/bin/wine "$@"
  '';

  flStudioInit = pkgs.writeShellScriptBin "fl-studio-init" ''
    set -euo pipefail
    export WINEPREFIX="${cfg.prefix}"
    export WINEARCH="win64"

    echo "==> Initializing Wine prefix at: $WINEPREFIX"
    mkdir -p "$WINEPREFIX"
    ${cfg.package}/bin/wineboot -u

    echo "==> Installing Windows dependencies with winetricks..."
    ${pkgs.winetricks}/bin/winetricks -q ${toString cfg.winetricksPackages}

    echo "==> Ensuring VST directory structure exists in prefix..."
    mkdir -p \
      "$WINEPREFIX/drive_c/Program Files/Common Files/VST3" \
      "$WINEPREFIX/drive_c/Program Files/VstPlugins" \
      "$WINEPREFIX/drive_c/Program Files/Common Files/CLAP" \
      "$WINEPREFIX/drive_c/Program Files/Steinberg/VstPlugins"

    mkdir -p "$HOME/.vst" "$HOME/.vst3" "$HOME/.clap"

    echo "==> Wine prefix setup complete."
  '';

  flStudioBridgeSync = pkgs.writeShellScriptBin "fl-studio-bridge-sync" ''
    set -euo pipefail
    mkdir -p "$HOME/.vst" "$HOME/.vst3" "$HOME/.clap"
    echo "==> Synchronizing yabridge VST plugins..."
    ${pkgs.yabridgectl}/bin/yabridgectl sync --prune
    ${pkgs.yabridgectl}/bin/yabridgectl status
  '';

  flStudioInstall = pkgs.writeShellScriptBin "fl-studio-install" ''
    set -euo pipefail
    if [ $# -lt 1 ]; then
      echo "Usage: fl-studio-install <path-to-installer.exe>" >&2
      exit 1
    fi

    export WINEPREFIX="${cfg.prefix}"
    export WINEARCH="win64"

    if [ ! -d "$WINEPREFIX/drive_c" ]; then
      echo "Prefix does not exist yet. Initializing first..."
      ${flStudioInit}/bin/fl-studio-init
    fi

    echo "==> Running installer: $1"
    ${cfg.package}/bin/wine "$@"

    if ${lib.boolToString cfg.yabridge.enable}; then
      echo "==> Syncing yabridge after installation..."
      ${flStudioBridgeSync}/bin/fl-studio-bridge-sync
    fi
  '';

  flStudioApp = pkgs.writeShellScriptBin "fl-studio" ''
    set -euo pipefail
    export WINEPREFIX="${cfg.prefix}"
    export WINEARCH="win64"
    export WINEDEBUG="-all"

    FL_CANDIDATES=(
      ${lib.optionalString (cfg.executablePath != null) ''"${cfg.executablePath}"''}
      "$WINEPREFIX/drive_c/Program Files/Image-Line/FL Studio 2026/FL64.exe"
      "$WINEPREFIX/drive_c/Program Files/Image-Line/FL Studio 2024/FL64.exe"
      "$WINEPREFIX/drive_c/Program Files/Image-Line/FL Studio 21/FL64.exe"
      "$WINEPREFIX/drive_c/Program Files/Image-Line/FL Studio 20/FL64.exe"
      "$WINEPREFIX/drive_c/Program Files/Image-Line/FL Studio/FL64.exe"
    )

    FL_EXE=""
    for candidate in "''${FL_CANDIDATES[@]}"; do
      if [ -n "$candidate" ] && [ -f "$candidate" ]; then
        FL_EXE="$candidate"
        break
      fi
    done

    if [ -z "$FL_EXE" ] && [ -d "$WINEPREFIX/drive_c/Program Files/Image-Line" ]; then
      FL_EXE=$(find "$WINEPREFIX/drive_c/Program Files/Image-Line" -maxdepth 3 -name "FL64.exe" 2>/dev/null | head -n 1 || true)
    fi

    if [ -z "$FL_EXE" ] || [ ! -f "$FL_EXE" ]; then
      echo "Error: FL Studio executable not found in prefix: $WINEPREFIX" >&2
      echo "If you haven't installed FL Studio yet, run:" >&2
      echo "  fl-studio-init" >&2
      echo "  fl-studio-install /path/to/flstudio_installer.exe" >&2
      exit 1
    fi

    exec ${cfg.package}/bin/wine "$FL_EXE" "$@"
  '';
in
{
  options.programs.fl-studio = {
    enable =
      mkEnableOption "FL Studio Wine environment, declarative management, and yabridge VST bridge"
      // {
        default = true;
      };

    prefix = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.local/share/wineprefixes/fl-studio";
      description = "Dedicated Wine prefix directory for FL Studio.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wineWow64Packages.staging;
      description = "Wine package to use for FL Studio.";
    };

    executablePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Explicit path to FL64.exe (falls back to auto-discovery).";
    };

    winetricksPackages = mkOption {
      type = types.listOf types.str;
      default = [
        "corefonts"
        "gdiplus"
        "vcrun2022"
        "d3dcompiler_47"
      ];
      description = "Winetricks packages/verbs to install into the prefix.";
    };

    vstDirectories = mkOption {
      type = types.listOf types.str;
      default = [
        "${cfg.prefix}/drive_c/Program Files/Common Files/VST3"
        "${cfg.prefix}/drive_c/Program Files/VstPlugins"
        "${cfg.prefix}/drive_c/Program Files/Common Files/CLAP"
        "${cfg.prefix}/drive_c/Program Files/Steinberg/VstPlugins"
      ];
      description = "List of Windows VST/VST3/CLAP directories to bridge with yabridge.";
    };

    yabridge = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable yabridge and yabridgectl for bridging VST plugins.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.winetricks
      pkgs.cabextract
      pkgs.zenity
      flStudioApp
      flStudioWine
      flStudioInit
      flStudioInstall
    ]
    ++ lib.optionals cfg.yabridge.enable [
      pkgs.yabridge
      pkgs.yabridgectl
      flStudioBridgeSync
    ];

    # Declarative yabridgectl configuration
    xdg.configFile."yabridgectl/config.toml" = mkIf cfg.yabridge.enable {
      text = ''
        # Managed declaratively by Home Manager (fl-studio.nix)
        plugin_dirs = [
          ${concatMapStringsSep ",\n  " (dir: ''"${dir}"'') cfg.vstDirectories}
        ]
      '';
    };

    # Declarative desktop entry
    xdg.desktopEntries.fl-studio = {
      name = "FL Studio";
      genericName = "Digital Audio Workstation";
      comment = "FL Studio in dedicated Wine prefix";
      exec = if (config ? useUWSM && config.useUWSM) then "uwsm app -- fl-studio %F" else "fl-studio %F";
      icon = "wine";
      terminal = false;
      type = "Application";
      categories = [
        "AudioVideo"
        "Audio"
        "Midi"
        "Music"
      ];
      mimeType = [ "application/x-flp" ];
      settings = {
        StartupWMClass = "FL64.exe";
      };
    };
  };
}
