{
  lib,
  fetchFromGitHub,
  vimUtils,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "mega.cmdparse";
  version = "unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "ColinKennedy";
    repo = "mega.cmdparse";
    rev = "47ea5b1b23059fbb79a8e262002f32e7cd8aed90";
    hash = "sha256-RgRsHt1O6UQ/90JeAkHvdpgfjF+I25zg/oGV0cK7t6U=";
  };

  dependencies = [
    vimPlugins.mega-logging
  ];

  meta = {
    description = "A Neovim command-mode parser. Similar to Python's argparse module";
    homepage = "https://github.com/ColinKennedy/mega.cmdparse";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
