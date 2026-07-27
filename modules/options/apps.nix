{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    useUWSM = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to wrap desktop applications with UWSM";
    };
    defaultApps = {
      browser = mkOption {
        type = types.str;
        default = "zen";
        description = "Default browser command";
      };
      launcher = mkOption {
        type = types.str;
        default = "vicinae";
        description = "Default launcher command";
      };
      terminal = mkOption {
        type = types.str;
        default = "ghostty";
        description = "Default terminal command";
      };
      fileManager = mkOption {
        type = types.str;
        default = "yazi";
        description = "Default file manager command";
      };
    };
  };
}

