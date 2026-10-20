{
  lib,
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "mega.logging";
  version = "unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "ColinKennedy";
    repo = "mega.logging";
    rev = "194ad8c300186e73c3eb1ebeb3ede42eb219be3b";
    hash = "sha256-hV7uJyu0XszGLOvcRcDNDE9P6d8GTxBX+la1lQVxx2s=";
  };

  meta = {
    description = "Logging utility for Neovim";
    homepage = "https://github.com/ColinKennedy/mega.logging";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
