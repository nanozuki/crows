local crows = require('crows')

---@type Feature
local editor = { plugins = {} }

local function set_filetype()
  vim.cmd([[filetype on]])
  vim.cmd([[filetype plugin on]])
  vim.g.do_filetype_lua = 1
  vim.g.did_load_filetypes = 1
  local filetypes = {
    ['*html'] = 'html',
    ['tsconfig.json'] = 'jsonc',
  }
  local ft_group = vim.api.nvim_create_augroup('filetypes', {})
  for pattern, filetype in pairs(filetypes) do
    vim.api.nvim_create_autocmd(
      { 'BufNewFile', 'BufRead' },
      { group = ft_group, pattern = pattern, command = 'setfiletype ' .. filetype, once = true }
    )
  end
end

editor.pre = function()
  vim.cmd('syntax enable')
  vim.opt.foldmethod = 'indent'
  vim.opt.foldlevelstart = 99
  -- ignore file for all
  vim.cmd('set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store')

  set_filetype()

  -- setup indent
  vim.cmd('filetype indent on')
  vim.opt.cindent = true
  vim.opt.expandtab = true
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4
  local fi_group = vim.api.nvim_create_augroup('fileindent', {})
  vim.api.nvim_create_autocmd('FileType', {
    group = fi_group,
    pattern = 'lua,javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json',
    command = 'setlocal expandtab ts=2 sw=2 sts=2',
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
      ignore_install = { 'php', 'phpdoc' },
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
