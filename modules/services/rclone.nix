{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.services.rcloneSync;

  mkSyncService = remote: {
    Unit = {
      Description = "Rclone periodic background sync for ${remote}";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/Drive/${remote}";
      ExecStart = "${pkgs.rclone}/bin/rclone sync ${remote}: ${config.home.homeDirectory}/Drive/${remote} --fast-list --transfers 4 --checkers 8 --log-level NOTICE";

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = [ "${config.home.homeDirectory}/Drive/${remote}" ];
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictRealtime = true;
      RestrictNamespaces = true;
    };
  };

  mkSyncTimer = remote: {
    Unit = {
      Description = "Timer for rclone periodic background sync on ${remote}";
    };
    Timer = {
      OnCalendar = cfg.interval;
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
in
{
  options.services.rcloneSync = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable periodic rclone background sync systemd user services and timers.";
    };
    remotes = mkOption {
      type = types.listOf types.str;
      default = [
        "gdrive"
      ];
      description = "List of rclone remotes to sync into ~/Drive/<remote>.";
    };
    interval = mkOption {
      type = types.str;
      default = "*:0/30";
      description = "Systemd OnCalendar interval expression for sync frequency.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.rclone ];

    systemd.user.services = lib.listToAttrs (
      map (remote: {
        name = "rclone-sync-${remote}";
        value = mkSyncService remote;
      }) cfg.remotes
    );

    systemd.user.timers = lib.listToAttrs (
      map (remote: {
        name = "rclone-sync-${remote}";
        value = mkSyncTimer remote;
      }) cfg.remotes
    );
  };
}
