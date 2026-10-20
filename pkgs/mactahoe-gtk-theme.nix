{
  fetchFromGitHub,
  stdenvNoCC,
  sassc,
  glib,
  libxml2,
  unixtools,
  jdupes,
  util-linux,
}:
let
  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-gtk-theme";
    rev = "1e45e19f510edb8cde18fa84d6cd5319f60b086b";
    hash = "sha256-6a42HU49N4ChSm4AyW7i6FYAIENZzDogpZzM51muCbg=";
  };

  # Installed theme and runtime accent compile (pkgs/mactahoe-gtk-accent.nix
  # reads mactahoe-gtk-theme.src) share this patched source, so the hook
  # cannot reset these non-color tokens to pristine upstream values.
  source = stdenvNoCC.mkDerivation {
    pname = "mactahoe-gtk-theme-source";
    version = "latest";

    inherit src;

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done

      # Do not provide `sudo`, as it is not needed in our use case of the install script
      substituteInPlace libs/lib-core.sh --replace-fail '$(command -v sudo)' false

      # Provides a dummy home directory
      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'

      # Keep install stderr visible and avoid terminal clearing
      sed -i 's/exec 2>.*/# removed exec/' libs/lib-core.sh
      sed -i 's/clear/true/g' libs/lib-core.sh
      sed -i 's/clear/true/g' install.sh
      substituteInPlace install.sh --replace-fail 'install_app' 'true'
      sed -i 's/\$GNOME_SHELL:.*/\$GNOME_SHELL: true;/' $(find . -type f -name "*.scss")

      # One radius for window, dialog, menu, popover, and OSD, plus translucent
      # backgrounds. $trans_opacity covers menu, dialog, and OSD; --blur below
      # keeps window and sidebar at 0.75.
      substituteInPlace src/sass/_variables.scss \
        --replace-fail "\$wm_radius: if(\$laptop == 'false', 26px, 24px);" "\$wm_radius: 12px;" \
        --replace-fail "\$bd_radius: if(\$laptop == 'false', 10px, 8px);" "\$bd_radius: 12px;" \
        --replace-fail "\$modal_radius: 24px + \$base_padding * 3;" "\$modal_radius: 12px;" \
        --replace-fail "\$trans_opacity: 0.96;" "\$trans_opacity: 0.82;" \
        --replace-fail "\$mn_radius: if(\$laptop == 'false', 14px, 12px);" "\$mn_radius: 12px;" \
        --replace-fail "\$po_radius: if(\$laptop == 'false', 16px, 14px);" "\$po_radius: 12px;"
    '';

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -a ./. $out/
    '';
  };
in
stdenvNoCC.mkDerivation (_: {
  pname = "mactahoe-gtk-theme";
  version = "latest";

  src = source;

  nativeBuildInputs = [
    sassc
    glib
    libxml2
    jdupes
    unixtools.getent
    util-linux
  ];

  # propagatedUserEnvPkgs = [
  # ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    HOME="$TMPDIR" ./install.sh \
      --color light --color dark \
      --opacity normal \
      --theme default \
      --scheme standard \
      --round \
      --blur \
      --dest $out/share/themes

    find $out -type l ! -exec test -e {} \; -delete

    jdupes --quiet --link-hard --recurse $out/share

    runHook postInstall
  '';
})
