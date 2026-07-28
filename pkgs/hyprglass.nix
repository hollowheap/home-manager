{
  stable,
  cmake,
  lib,
  fetchFromGitHub,
}:
stable.hyprlandPlugins.mkHyprlandPlugin (_: {
  pluginName = "hyprglass";
  version = "0.6.1";

  src = stable.fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "v0.6.1";
    hash = "sha256-044bxcqawwbxlr75sdmf81w0k5n0nppmwv6d843lgdp208y9aazi";
  };

  nativeBuildInputs = [
    stable.cmake
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
