{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "fzf-tab-source";
  version = "unstable-2024-03-01";

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "fzf-tab-source";
    rev = "master";
    sha256 = "sha256-d7+yKrHp4Vcl5WlQfQ/UMNK5j3wz8Ls168Cuj1LYTgI=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fzf-tab-source
    cp -r bin functions sources fzf-tab-source.plugin.zsh $out/share/fzf-tab-source/
  '';

  meta = {
    description = "A collection of sources for fzf-tab";
    homepage = "https://github.com/Freed-Wu/fzf-tab-source";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
