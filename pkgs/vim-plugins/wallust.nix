{
  lib,
  vimUtils,
  runCommandLocal,
}:
vimUtils.buildVimPlugin {
  pname = "wallust.nvim";
  version = "1.0.0";

  src = runCommandLocal "wallust-nvim-src" { } ''
    mkdir -p $out/lua
    cat <<'EOF' > $out/lua/wallust.lua
    -- Dynamic bridge to Wallust-generated palette in ~/.config/nvf/lua/wallust.lua
    local rendered = vim.fn.expand("~/.config/nvf/lua/wallust.lua")
    if vim.uv.fs_stat(rendered) then
      local chunk, err = loadfile(rendered)
      if chunk then
        return chunk()
      end
    end
    return {
      setup = function() end,
    }
    EOF
  '';

  meta = {
    description = "Dynamic Wallust color theme loader for Neovim";
    platforms = lib.platforms.all;
  };
}
