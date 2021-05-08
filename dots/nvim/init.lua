-- Nanozuki Vim Config

local opt = require'utils'.opt
local noremap = require'utils'.noremap
local map = require'utils'.map

--- basic & misc {{{
vim.g.mapleader = ' '
opt('w', 'linebreak', true)
opt('o', 'showbreak', '->')
opt('o', 'mouse', 'ar')
opt('w', 'number', true)
opt('w', 'relativenumber', true)
opt('w', 'colorcolumn', '120')
opt('o', 'modelines', 1)
--- }}}

--- edit {{{
vim.cmd 'syntax enable'
opt('w', 'foldmethod', 'indent')
opt('o', 'foldlevelstart', 99)
-- copy selection to system clipboard
noremap('v', '<Leader>y', '"+y')
-- paste from system clipboard
noremap('n', '<Leader>p', '"+p')
-- ignore file for all
vim.cmd 'set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store'
-- save as sudo
noremap('c', 'w!!', 'w !sudo tee %')

vim.api.nvim_exec(
[[
augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *html         setfiletype html
    autocmd BufNewFile,BufRead *.jsx         setfiletype javascript.tsx
    autocmd BufNewFile,BufRead *.tsx         setfiletype typescript.tsx
    autocmd BufNewFile,BufRead tsconfig.json setfiletype jsonc
    autocmd BufNewFile,BufRead *.zig         setfiletype zig
augroup end
]]
, true)
--- }}}

-- search & replace {{{
noremap('n', '<leader>/', ':nohlsearch<CR>')
opt('o', 'ignorecase', true)
-- }}}

-- indent {{{
vim.cmd 'filetype indent on'
opt('b', 'expandtab', true)
opt('b', 'tabstop', 4)
opt('b', 'shiftwidth', 4)
opt('b', 'softtabstop', 4)

vim.api.nvim_exec(
[[
augroup fileindent
    autocmd!
    autocmd FileType javascript,typescript,html,css,scss,xml,yaml,json,wxss,wxml,lua setlocal expandtab ts=2 sw=2 sts=2
augroup end
]]
, true)
--- }}}

require 'plugins'

--- [plugin] colorscheme {{{
opt('o', 'termguicolors', true)
local function set_colorscheme(name, mode)
  if name == 'gruvbox' then
    vim.cmd 'colorscheme gruvbox'
    vim.g['gruvbox_italic'] = 1
    vim.g['airline_theme'] = "gruvbox"
    if mode == 'dark' then
      opt('o', 'background', 'dark')
    else
      opt('o', 'background', 'light')
    end
  elseif name == 'onehalf' then
    if mode == 'dark' then
      vim.cmd 'colorscheme onehalfdark'
      vim.g['airline_theme'] = 'onehalfdark'
    else
      vim.cmd 'colorscheme onehalflight'
      vim.g['airline_theme'] = 'onehalflight'
    end
  elseif name == 'nord' then
    vim.cmd 'colorscheme nord'
    vim.g['airline_theme'] = 'nord'
  end
  return
end
set_colorscheme('nord', 'dark')
-- }}}

--- [plugin] nvim-treesitter {{{
require'nvim-treesitter.configs'.setup{ensure_installed = 'maintained', highlight = {enable = true}}
--- }}}

--- [plugin] airline {{{
vim.g['airline_powerline_fonts'] = 1
vim.g['airline_extensions'] = {'tabline', 'branch', 'virtualenv'}
vim.g['airline#extensions#tabline#buffer_idx_mode'] = 1
for i = 0, 9 do
  map('n', '<leader>'..i, '<Plug>AirlineSelectTab'..i)
end
map('n', '<leader>-', '<Plug>AirlineSelectPrevTab')
map('n', '<leader>+', '<Plug>AirlineSelectNextTab')
--- }}}

--- [plugin] indentline {{{
vim.cmd 'set list lcs=tab:\\¦\\ '
vim.cmd 'autocmd Filetype json let g:indentLine_enabled = 0'
--- }}}

--- [plugin] ultisnips {{{
vim.g['UltiSnipsExpandTrigger'] = "<c-e>"
vim.g['UltiSnipsJumpForwardTrigger'] = "<c-e>"
vim.g['UltiSnipsJumpBackwardTrigger'] = "<c-h>"
--- }}}

--- [plugin] nerdtree {{{
noremap('', '<Leader>fl', ':NERDTreeToggle<CR>')
vim.g['NERDTreeWinSize'] = 32
vim.g['NERDTreeWinPos'] = "left"
vim.g['NERDTreeShowHidden'] = 1
vim.g['NERDTreeMinimalUI'] = 1
vim.g['NERDTreeAutoDeleteBuffer'] = 1
--- }}}

--- [plugin] ctrlsf {{{
vim.g['ctrlsf_ackprg'] = 'rg'
noremap('', '<leader>sf', ':CtrlSF ') -- search current name
noremap('', '<leader>sp', ':CtrlSF<CR>') -- search in project
--- }}}

--- [plugin] fzf {{{
vim.g.fzf_layout = { window = { width = 0.9, height = 0.8 } }
vim.g.fzf_colors = {
  gutter = {'bg', 'Tabline'},
  ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
  ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
  ['hl'] = {'fg', 'Special'},
  ['hl+'] = {'fg', 'Statement'},
}
noremap('', '<C-p>', ':Files<CR>')
--- }}}

require'lsp_settings'

-- [plugin] vim-go {{{
vim.g['go_fmt_command'] = "goimports"
vim.g['go_auto_type_info'] = 1
vim.g['go_def_mode'] = 'gopls'
vim.g['go_info_mode'] = 'gopls'
-- use lsp to lint and code completion
vim.g['go_code_completion_enabled'] = 0
vim.g['go_def_mapping_enabled'] = 0
vim.g['go_doc_keywordprg_enabled'] = 0
vim.g['go_textobj_enabled'] = 0
vim.g['go_metalinter_enable'] = 0
-- }}}

-- [plugin] rust.vim {{{
vim.g['rustfmt_autosave'] = 1
-- }}}

-- [plugin] completion-nvim {{{
-- completion
require'completion_nvim'.on_attach()
-- }}}

-- vim:foldmethod=marker:foldlevel=0
