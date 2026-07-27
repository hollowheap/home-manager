{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.theme.dims = {
    # Standard Border Options
    border = {
      size = mkOption {
        type = types.int;
        default = 1;
        description = "Standard window border thickness.";
      };

      radius = mkOption {
        type = types.int;
        default = 8;
        description = "Corner rounding radius for standard windows.";
      };

      rounding_power = mkOption {
        type = types.number;
        default = 2.0;
        description = "Continuous rounding (squircle) power for standard windows.";
      };
    };

    # Small Border Options
    borderSmall = {
      size = mkOption {
        type = types.int;
        default = 1;
        description = "Thin window border thickness for specific UI elements.";
      };

      radius = mkOption {
        type = types.int;
        default = 4;
        description = "Corner rounding radius for thin-bordered UI elements.";
      };

      rounding_power = mkOption {
        type = types.number;
        default = 2.0;
        description = "Continuous rounding (squircle) power for thin-bordered elements.";
      };
    };

    # Margin Options
    margin = {
      inner = mkOption {
        type = types.int;
        default = 8;
        description = "Inner gaps between adjacent windows.";
      };

      outer = mkOption {
        type = types.int;
        default = 12;
        description = "Outer gaps between windows and the edge of the monitor.";
      };
    };

    # Global Dimensions
    barHeight = mkOption {
      type = types.int;
      default = 20;
      description = "Global height dimension for your status bar (e.g., MangoWC).";
    };
  };
}
