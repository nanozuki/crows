local crows = require('crows')
local augroup = require('crows.util').augroup
local autocmd = require('crows.util').autocmd

-- display sign for marks
crows.plugin.use('kshenoy/vim-signature')

-- multi select and edit
crows.plugin.use('mg979/vim-visual-multi')

-- autopairs
crows.plugin.use('Raimondi/delimitMate')
vim.g.delimitMate_expand_cr = 1
vim.g.delimitMate_expand_space = 1

-- surround edit
crows.plugin.use('machakann/vim-sandwich')
vim.cmd('syntax enable')
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
-- ignore file for all
vim.cmd('set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store')
augroup('filetypes', {
  autocmd('BufNewFile,BufRead', '*html', 'setfiletype html'),
  autocmd('BufNewFile,BufRead', 'tsconfig.json', 'setfiletype jsonc'),
  autocmd('BufNewFile,BufRead', '*.zig', 'setfiletype zig'),
})
crows.key.map('Copy to system clipboard', 'v', '<leader>y', '"+y')
crows.key.map('Paste from system clipboard', 'n', '<leader>p', '"+p')
crows.key.map('Save as sudo', 'c', 'w!!', 'w !sudo tee %')

-- indent hint
crows.plugin.use({
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup({
      char = '¦',
      buftype_exclude = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
    })
  end,
})

-- setup indent
vim.cmd('filetype indent on')
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
augroup('fileindent', {
  autocmd(
    'FileType',
    'lua,javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json',
    'setlocal expandtab ts=2 sw=2 sts=2'
  ),
})

-- treesitter
crows.plugin.use({
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = 'maintained',
      highlight = { enable = true },
    })
  end,
})

-- git manage
crows.plugin.use('tpope/vim-fugitive')
crows.plugin.use({
  'TimUntersberger/neogit',
  requires = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  config = function()
    require('neogit').setup({
      integrations = { diffview = true },
    })
  end,
})
