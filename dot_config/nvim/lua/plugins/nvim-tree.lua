require('nvim-tree').setup({
  disable_netrw = false,
  update_cwd = true,
  diagnostics = { enable = true },
  view = { signcolumn = 'auto' },
  git = {
    ignore = false,
  },
})
vim.keymap.set('n', '<Leader>fl', ':NvimTreeToggle<CR>', { desc = 'Toggle filetree' })
