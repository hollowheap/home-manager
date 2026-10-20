{
  lib,
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "foldtext.nvim";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "OXY2DEV";
    repo = "foldtext.nvim";
    rev = "v2.0.0";
    hash = "sha256-jOcspms+hJEe9G+qSD/ytNo5uLgv29DAGdSGn0Az6Fg=";
  };

  meta = {
    description = "Foldtext configuration in Lua for Neovim";
    homepage = "https://github.com/OXY2DEV/foldtext.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
