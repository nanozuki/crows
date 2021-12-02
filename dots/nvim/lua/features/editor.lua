local feature = require('fur.feature')
local augroup = require('lib.util').augroup
local autocmd = require('lib.util').autocmd

local editor = feature:new('editor')
editor.source = 'lua/features/editor.lua'
editor.plugins = {
  'kshenoy/vim-signature', -- display sign for marks
  'mg979/vim-visual-multi',
  'tpope/vim-surround', -- cs"': "a"->'a', ysiw]: word->[word], cs]{: [word]->{ word }
}
editor.setup = function()
  vim.cmd('syntax enable')
  vim.opt.foldmethod = 'indent'
  vim.opt.foldlevelstart = 99
  vim.cmd('set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store') -- ignore file for all
  augroup('filetypes', {
    autocmd('BufNewFile,BufRead', '*html', 'setfiletype html'),
    autocmd('BufNewFile,BufRead', 'tsconfig.json', 'setfiletype jsonc'),
    autocmd('BufNewFile,BufRead', '*.zig', 'setfiletype zig'),
  })
end
editor.mappings = {
  { 'v', '<Leader>y', '"+y' }, -- copy selection to system clipboard
  { 'n', '<Leader>p', '"+p' }, -- paste from system clipboard
  { 'c', 'w!!', 'w !sudo tee %' }, -- save as sudo
}

local indent = feature:new('indent')
indent.plugins = {
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '¦',
        -- show_first_indent_level = false,
        buftype_exclude = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
      })
    end,
  }, -- display hint for indent
}
indent.setup = function()
  vim.cmd('filetype indent on')
  vim.opt.expandtab = true
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4
  augroup('fileindent', {
    autocmd(
      'FileType',
      'javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json',
      'setlocal expandtab ts=2 sw=2 sts=2'
    ),
  })
end

local treesitter = feature:new('treesitter')
treesitter.plugins = {
  {
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
  },
}

local git = feature:new('git')
git.plugins = {
  {
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
  },
}

editor.children = { indent, treesitter, git }
return editor
