{
  lib,
  fetchFromGitHub,
  vimUtils,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-supermaven";
  version = "unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "Huijiro";
    repo = "blink-cmp-supermaven";
    rev = "635ce12e9e2d2a5a483728ac764d0bc5b57af23b";
    hash = "sha256-pVu58uzakRdAr89I7e4xotBTr9sd5QWkQQlCs2PeFjg=";
  };

  dependencies = with vimPlugins; [
    blink-cmp
  ];

  doCheck = false;

  meta = {
    description = "Supermaven source for blink.cmp";
    homepage = "https://github.com/Huijiro/blink-cmp-supermaven";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
