require('nvim-tree').setup({
  disable_netrw = false,
  update_cwd = true,
  diagnostics = { enable = true },
  view = { signcolumn = 'auto' },
  git = {
    ignore = false,
  },
})
require('crows').key.map('Toggle filetree', 'n', '<Leader>fl', ':NvimTreeToggle<CR>')
