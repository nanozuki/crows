---@alias Theme 'gruvbox_light'|'gruvbox_dark'|'edge_light'|'nord'|'rose_pine_dawn'

return {
  ---@type Theme
  theme = 'rose_pine_dawn',
  ---@type table<string, boolean>
  opt_languages = {
    go = true,
    rust = true,
    typescript = true,
    terraform = true,
    zig = true,
  },
}
