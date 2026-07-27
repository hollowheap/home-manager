{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.hyprPlugins.hyprglass = {
    tint_color = mkOption {
      type = types.int;
      default = 0;
      description = "Tint color";
    };

    brightness = mkOption {
      type = types.float;
      default = 1.0;
      description = "Brightness";
    };

    blur_strength = mkOption {
      type = types.float;
      default = 10.0;
      description = "Blur strength";
    };

    blur_iterations = mkOption {
      type = types.int;
      default = 5;
      description = "Blur iterations";
    };

    refraction_strength = mkOption {
      type = types.float;
      default = 0.12;
      description = "Chromatic aberration";
    };

    fresnel_strength = mkOption {
      type = types.float;
      default = 0.6;
      description = "Refraction strength";
    };

    specular_strength = mkOption {
      type = types.float;
      default = 0.5;
      description = "Specular strength";
    };

    glass_opacity = mkOption {
      type = types.float;
      default = 0.1;
      description = "Glass opacity";
    };

    lens_distortion = mkOption {
      type = types.float;
      default = 1.0;
      description = "Lens distortion";
    };

    edge_thickness = mkOption {
      type = types.float;
      default = 15.0;
      description = "Edge thickness";
    };
  };
}
