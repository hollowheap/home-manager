-- wallust template (minijinja) -> rendered to ~/.config/nvf/lua/wallust.lua
--
-- Ported from the noctalia nvim-colors.lua template. Keeps the same module
-- shape: M.setup() feeds a base16 palette into base16-colorscheme, and a
-- SIGUSR1 handler hot-reloads the palette + lualine theme when wallust fires
-- its post-run hook (`pkill -SIGUSR1 nvim`), mirroring noctalia's behaviour.
--
-- Noctalia M3 roles are mapped onto wallust ansi slots. base16-colorscheme
-- expects '#RRGGBB' values, so the '#'-prefixed `{{colorN}}` form is used.
--
-- PIN: base00 (background) is pinned to #000000 and base07 (lightest fg) to
-- #ffffff via hardcoded literals instead of {{color0}}/{{color15}}, so the pin
-- holds regardless of palette extraction.
local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    -- Background tones
    base00 = '#000000',       -- Default Background (PINNED pure black)
    base01 = '{{color8}}',    -- Lighter Background (status bars)
    base02 = '{{color10}}',   -- Selection Background
    base03 = '{{color11}}',   -- Comments, Invisibles
    -- Foreground tones
    base04 = '{{color12}}',   -- Dark Foreground (status bars)
    base05 = '{{color7}}',    -- Default Foreground
    base06 = '{{color13}}',   -- Light Foreground
    base07 = '#ffffff',       -- Lightest Foreground (PINNED pure white)
    -- Accent colors
    base08 = '{{color1}}',    -- Variables, XML Tags, Errors
    base09 = '{{color9}}',    -- Integers, Constants
    base0A = '{{color3}}',    -- Classes, Search Background
    base0B = '{{color2}}',    -- Strings, Diff Inserted
    base0C = '{{color6}}',    -- Regex, Escape Chars
    base0D = '{{color4}}',    -- Functions, Methods
    base0E = '{{color5}}',    -- Keywords, Storage
    base0F = '{{color14}}',   -- Deprecated, Embedded Tags
  })
end

if not _G._wallust_signal then
  _G._wallust_signal = vim.uv.new_signal()
  _G._wallust_signal:start('sigusr1',
    vim.schedule_wrap(function()
      package.loaded['wallust'] = nil
      require('wallust').setup()
      if _G.update_lualine_theme then
        _G.update_lualine_theme()
      end
    end)
  )
end

return M
