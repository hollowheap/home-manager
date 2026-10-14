{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool str;
in
{
  options = {
    useUWSM = mkOption {
      type = bool;
      default = true;
      description = "Whether to wrap desktop applications with UWSM";
    };
    defaultApps = {
      browser = mkOption {
        type = str;
        default = "zen-twilight";
        description = "Default browser command";
      };
      launcher = mkOption {
        type = str;
        default = "noctalia msg panel-toggle launcher";
        description = "Default launcher command";
      };
      terminal = mkOption {
        type = str;
        default = "ghostty";
        description = "Default terminal command";
      };
      fileManager = mkOption {
        type = str;
        default = "yazi";
        description = "Default file manager command";
      };
      mail = mkOption {
        type = str;
        default = "thunderbird";
        description = "Default mail client command";
      };
    };
  };
}

