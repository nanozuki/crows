set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set termguicolors

" Nanozuki Vim Config

" basic & misc {{{
" line wrap
set wrap
set linebreak
"let &showbreak = ' ↪'
let &showbreak = '->'

"" leader
let mapleader=" "
filetype on
filetype plugin on
" }}}

" shortcuts {{{
"" switch window
nnoremap <Leader>nw <C-W><C-W>
nnoremap <Leader>lw <C-W>l
nnoremap <Leader>hw <C-W>h
nnoremap <Leader>kw <C-W>k
nnoremap <Leader>jw <C-W>j

nnoremap <Leader>b ^
nnoremap <Leader>e $
" }}}

" edit {{{
set foldmethod=indent
set foldlevelstart=99
" copy selection to system clipboard
vnoremap <Leader>y "+y
" paste from system clipboard
nnoremap <Leader>p "+p
" completion for vim command
set wildmenu
"" ignore file for all
set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,
" save as sudo
cmap w!! w !sudo tee %
" }}}

" search & replace {{{
set modelines=1
set hlsearch
nnoremap <leader>/ :nohlsearch<CR>
set incsearch
set ignorecase
" }}}

" [plugin] vim-plug {{{
call plug#begin('~/.vim/plugins')
" edit code
Plug 'kshenoy/vim-signature'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
" read code
Plug 'tpope/vim-fugitive'
" javascript/react
Plug 'mattn/emmet-vim'
""" Initialize plugin system
call plug#end()
" }}}

" vim:foldmethod=marker:foldlevel=0
