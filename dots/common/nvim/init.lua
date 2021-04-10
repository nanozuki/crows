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

vim.api.nvim_exec(
[[

" search & replace {{{
set modelines=1
nnoremap <leader>/ :nohlsearch<CR>
set ignorecase
" }}}

" indent {{{
filetype indent on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
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
augroup end
" }}}

" [plugin] vim-plug {{{
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
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
" languages syntax and functions
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim', { 'for': 'go' }

""" Initialize plugin system
call plug#end()
" }}}

" [plugin] colorscheme {{{
set termguicolors
"" gruvbox
"colorscheme gruvbox
"let g:gruvbox_italic=1
"let g:airline_theme="gruvbox"
"" onehalf
"colorscheme onehalflight
"let g:airline_theme='onehalfdark'
"" nord
colorscheme nord
let g:airline_theme='nord'

"if $COLORMODE == 'dark'
"    set background=dark
"else
"    set background=light
"end
" }}}

" [plugin] airline {{{
let g:airline_powerline_fonts=1
let g:airline_extensions=['tabline', 'branch', 'virtualenv']
" let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#tabline#buffer_nr_show=1
" }}}

" [plugin] indentline {{{
set list lcs=tab:\¦\ 
autocmd Filetype json let g:indentLine_enabled = 0
" }}}

" [plugin] ultisnips {{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
" }}}

" [plugin] nerdtree {{{
nmap <Leader>fl :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
" }}}

" [plugin] ctrlsf {{{
let g:ctrlsf_ackprg = 'rg'
nmap <leader>sf :CtrlSF 
nmap <leader>sp :CtrlSF<CR>
" }}}

" [plugin] ctrlp {{{
let g:ctrlp_working_path_mode = 'a'
" }}}

" [plugin] vim-go {{{
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
" use lsp to lint and code completion
let g:go_code_completion_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_textobj_enabled = 0
let g:go_metalinter_enable= 0
" }}}

" [plugin] rust.vim {{{
let g:rustfmt_autosave = 1
" }}}

" [plugin] vim-lsp {{{

let g:lsp_settings = { 'golangci-lint-langserver': { 'initialization_options': { 'command': ['golangci-lint', 'run', '--config', '~/.config/nvim/golangci.yml', '--out-format', 'json'], }, }, 'rust-analyzer': { 'initialization_options': { 'diagnostics': { 'disabled': ['unresolved-proc-macro'] } } } }
let g:lsp_settings_root_markers = ['.git', '.git/', '.svn', '.hg', '.bzr', 'settings.json', 'go.mod', 'Cargo.toml', 'package.json']
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']
let g:lsp_settings_filetype_rust = 'rust-analyzer'

" register ultisnips
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({ 'name': 'ultisnips', 'allowlist': ['*'], 'completor': function('asyncomplete#sources#ultisnips#completor') }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({ 'name': 'buffer', 'allowlist': ['*'], 'completor': function('asyncomplete#sources#buffer#completor') }))

" vim-lsp shortcuts

augroup lsp_install
    au!
    " call lspmapping#on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call lspmapping#on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_signs_information = {'text': '!'}
let g:lsp_diagnostics_signs_hint = {'text': '!'}
highlight link LspHintHighlight SpellBad
highlight link LspInformationHighlight SpellCap
highlight link LspHintVirtualText Underlined
highlight link LspInformationVirtualText Underlined
" }}}

" [plugin] asyncomplete.vim {{{
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" allow modifying the completeopt variable, or it will
" be overridden all the time
let g:asyncomplete_auto_completeopt = 0

set completeopt=menuone,noinsert,noselect,preview

" To auto close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
"}}}
]]
, true)

-- vim:foldmethod=marker:foldlevel=1
