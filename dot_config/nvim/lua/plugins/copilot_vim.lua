vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-e>', [[copilot#Accept("\<CR>")]], {
  silent = true,
  expr = true,
  script = true,
})
