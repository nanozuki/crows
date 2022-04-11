local crows = require('crows')
local augroup = require('crows.util').augroup
local autocmd = require('crows.util').autocmd

---@type Feature
local editor = { plugins = {} }

editor.pre = function()
  vim.cmd('syntax enable')
  vim.opt.foldmethod = 'indent'
  vim.opt.foldlevelstart = 99
  -- ignore file for all
  vim.cmd('set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store')
  -- filetype
  augroup('filetypes', {
    autocmd('BufNewFile,BufRead', '*html', 'setfiletype html'),
    autocmd('BufNewFile,BufRead', 'tsconfig.json', 'setfiletype jsonc'),
    autocmd('BufNewFile,BufRead', '*.zig', 'setfiletype zig'),
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
end

-- display sign for marks
editor.plugins[1] = 'kshenoy/vim-signature'

-- multi select and edit
editor.plugins[2] = 'mg979/vim-visual-multi'

-- autopairs
editor.plugins[3] = {
  'windwp/nvim-autopairs',
  requires = { 'hrsh7th/nvim-cmp' },
  config = function()
    require('nvim-autopairs').setup({ check_ts = true })
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
  end,
}

-- surround edit
editor.plugins[4] = 'machakann/vim-sandwich'

-- indent hint
editor.plugins[5] = {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup({
      char = '¦',
      buftype_exclude = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
    })
  end,
}

-- treesitter
editor.plugins[6] = {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = 'all',
      highlight = { enable = true },
    })
  end,
}

-- git management
editor.plugins[7] = 'tpope/vim-fugitive'
editor.plugins[8] = {
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
}

editor.post = function()
  crows.key.map('Copy to system clipboard', 'v', '<leader>y', '"+y')
  crows.key.map('Paste from system clipboard', 'n', '<leader>p', '"+p')
  crows.key.map('Save as sudo', 'c', 'w!!', 'w !sudo tee %')
end

return editor
