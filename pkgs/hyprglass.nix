{
  hyprlandPlugins,
  cmake,
  lib,
  fetchFromGitHub,
}:
hyprlandPlugins.mkHyprlandPlugin (_: {
  pluginName = "hyprglass";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "v0.7.0";
    hash = "sha256-x/584kY+XXlU/OWKtZAFo89VtowjLXs1DiP9PC0o0Os=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  installPhase = ''
    mkdir -p $out/lib
    cp hyprglass.so $out/lib/libhyprglass.so
  '';

  meta = {
    description = "Hyprland plugin that adds blur, lens, diffraction, refraction effects to transparent windows";
    homepage = "https://github.com/hyprnux/hyprglass";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
