-- Nanozuki Vim Config

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--- basic & misc {{{
vim.g.mapleader = ' '
opt('w', 'linebreak', true)
opt('o', 'showbreak', '->')
opt('o', 'mouse', 'ar')
--- }}}

--- ui & layout {{{
opt('w', 'number', true)
opt('w', 'relativenumber', true)
opt('w', 'colorcolumn', '120')
--- }}}

--- edit {{{
vim.cmd 'syntax enable'
opt('w', 'foldmethod', 'indent')
opt('o', 'foldlevelstart', 99)
-- copy selection to system clipboard
map('v', '<Leader>y', '"+y')
-- paste from system clipboard
map('n', '<Leader>p', '"+p')
-- ignore file for all
vim.cmd 'set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*'
-- save as sudo
map('c', 'w!!', 'w !sudo tee %')

vim.api.nvim_exec(
[[
augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *html setfiletype html
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.tsx
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
    autocmd BufNewFile,BufRead tsconfig.json set filetype=jsonc
augroup end
]]
, true)
--- }}}

-- search & replace {{{
opt('o', 'modelines', 1)
map('n', '<leader>/', ':nohlsearch<CR>')
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
    autocmd FileType javascript setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType typescript setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType html setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType css setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType scss setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType xml setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType yaml setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType json setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType wxss setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType wxml setlocal expandtab ts=2 sw=2 sts=2
    autocmd FileType lua setlocal expandtab ts=2 sw=2 sts=2
augroup end
]]
, true)
--- }}}

-- [plugin] vim-plug {{{
vim.api.nvim_exec(
[[
call plug#begin('~/.config/nvim/plugins')
" appearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-sleuth'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }
Plug 'arcticicestudio/nord-vim'
" edit code
Plug 'kshenoy/vim-signature'
Plug 'scrooloose/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" read code
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'dyng/ctrlsf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'BurntSushi/ripgrep'
" lsp and complete
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" languages syntax and functions
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mattn/emmet-vim'
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim', { 'for': 'go' }

""" Initialize plugin system
call plug#end()
" }}}
]]
, true)
--- }}}

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
set_colorscheme('gruvbox', 'light')
-- }}}

--- [plugin] airline {{{
vim.g['airline_powerline_fonts'] = 1
vim.g['airline_extensions'] = {'tabline', 'branch', 'virtualenv'}
-- vim.g['airline#extensions#tabline#buffer_idx_mode'] = 1
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
--- }}}

--- [plugin] indentline {{{
vim.api.nvim_exec(
[[
set list lcs=tab:\¦\ 
autocmd Filetype json let g:indentLine_enabled = 0
]]
, true)
--- }}}

--- [plugin] ultisnips {{{
vim.g['UltiSnipsExpandTrigger'] = "<c-e>"
vim.g['UltiSnipsJumpForwardTrigger'] = "<c-e>"
vim.g['UltiSnipsJumpBackwardTrigger'] = "<c-h>"
--- }}}

--- [plugin] nerdtree {{{
map('', '<Leader>fl', ':NERDTreeToggle<CR>')
vim.g['NERDTreeWinSize'] = 32
vim.g['NERDTreeWinPos'] = "left"
vim.g['NERDTreeShowHidden'] = 1
vim.g['NERDTreeMinimalUI'] = 1
vim.g['NERDTreeAutoDeleteBuffer'] = 1
--- }}}

--- [plugin] ctrlsf {{{
vim.g['ctrlsf_ackprg'] = 'rg'
map('', '<leader>sf', ':CtrlSF ')
map('', '<leader>sp', ':CtrlSF<CR>')
--- }}}

-- [plugin] ctrlp {{{
vim.g['ctrlp_working_path_mode'] = 'a'
-- }}}

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
require'completion'.on_attach({
  confirm_key='',
  matching_strategy_list = {'substring', 'fuzzy', 'exact', 'all'},
  sorting = 'alphabet',
  enable_snippet = 'UltiSnips',
  enable_auto_popup = 1,
})
vim.api.nvim_exec(
[[
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" set shortmess+=c
]]
, true)
opt('o', 'completeopt', 'menuone,noinsert,noselect')
-- }}}

-- vim:foldmethod=marker:foldlevel=0
