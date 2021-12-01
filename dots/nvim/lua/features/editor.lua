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
  'tpope/vim-sleuth', -- smart detect indent of file
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

editor.children = { indent }
return editor
