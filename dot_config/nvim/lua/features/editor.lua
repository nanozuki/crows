local crows = require('crows')
local augroup = require('lib.util').augroup
local autocmd = require('lib.util').autocmd

-- display sign for marks
crows.use_plugin('kshenoy/vim-signature')

-- multi select and edit
crows.use_plugin('mg979/vim-visual-multi')

-- surround select and edit
-- cs"': "a"->'a', ysiw]: word->[word], cs]{: [word]->{ word }
crows.use_plugin('tpope/vim-surround')
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
crows.map('Copy to system clipboard', 'v', '<leader>y', '"+y')
crows.map('Paste from system clipboard', 'n', '<leader>p', '"+p')
crows.map('Save as sudo', 'c', 'w!!', 'w !sudo tee %')

-- indent hint
crows.use_plugin({
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup({
      char = '¦',
      -- show_first_indent_level = false,
      buftype_exclude = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
    })
  end,
})

-- setup indent
vim.cmd('filetype indent on')
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
crows.use_plugin({
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = 'maintained',
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = { ['<leader>a'] = '@parameter.inner' },
          swap_previous = { ['<leader>A'] = '@parameter.inner' },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      },
    })
  end,
})

-- git manage
crows.use_plugin({
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