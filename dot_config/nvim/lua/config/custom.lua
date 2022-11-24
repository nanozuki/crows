---@alias Theme 'gruvbox_light'|'gruvbox_dark'|'edge_light'|'nord'|'rose_pine_dawn'

return {
  ---@type Theme
  theme = 'rose_pine_dawn',
  built_in_languages = { 'lua', 'viml', 'json', 'yaml', 'markdown' },
  opt_languages = {
    go = true,
    ocaml = true,
    rust = true,
    typescript = true,
    terraform = true,
    zig = true,
  },
}
