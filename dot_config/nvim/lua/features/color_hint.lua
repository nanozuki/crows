---@type Feature
local color_hint = {}

color_hint.plugins = {
  { 'norcalli/nvim-colorizer.lua', opt = true },
}

function color_hint.toggle_colors()
  vim.cmd([[
    packadd nvim-colorizer.lua
    ColorizerToggle
  ]])
end

function color_hint.post()
  vim.cmd([[command! ToggleColors lua require('features.color_hint').toggle_colors()]])
end

return color_hint
