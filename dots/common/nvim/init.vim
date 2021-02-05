" Nanozuki Vim Config

" basic & misc {{{
" unicode support
let $LANG="en_US.UTF-8"
set langmenu=en_US.UTF-8
set fileencodings=UTF-8

" line wrap
set linebreak
let &showbreak = '->'

"" leader
let mapleader=" "

filetype on
filetype plugin on
set mouse=a
" }}}

" ui & layout {{{
set number
set relativenumber
" set cursorline
" set cursorcolumn
set colorcolumn=120
" }}}

" shortcuts {{{
"" switch window
nnoremap <Leader>nw <C-W><C-W>
nnoremap <Leader>lw <C-W>l
nnoremap <Leader>hw <C-W>h
nnoremap <Leader>kw <C-W>k
nnoremap <Leader>jw <C-W>j

"" session
nnoremap <leader>ss :mksession! ./.vimsession<cr> :wviminfo! ./.viminfo<cr>
nnoremap <leader>rs :source ./.vimsession<cr> :rviminfo ./.viminfo<cr>

nnoremap <Leader>b ^
nnoremap <Leader>e $
" }}}

" edit {{{
syntax enable
set foldmethod=indent
set foldlevelstart=99
" copy selection to system clipboard
vnoremap <Leader>y "+y
" paste from system clipboard
nnoremap <Leader>p "+p
"" ignore file for all
set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,
" save as sudo
cmap w!! w !sudo tee %

augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *html setfiletype html
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.tsx
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
    autocmd BufNewFile,BufRead tsconfig.json set filetype=jsonc
augroup end
" }}}

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
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
" javascript/react
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascript' }
Plug 'peitalin/vim-jsx-typescript', { 'for': ['typescript', 'typescriptreact'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescriptreact'] }
Plug 'mattn/emmet-vim'
" go
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'buoto/gotests-vim', { 'for': 'go' }
" rust
Plug 'rust-lang/rust.vim',
" fish
Plug 'dag/vim-fish'
" toml
Plug 'cespare/vim-toml'
" graphql
Plug 'jparise/vim-graphql'

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
" language specific config and register server
augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls']},
      \ 'allowlist': ['go'],
      \ })
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'golangci-lint-langserver',
      \ 'cmd': {server_info->['golangci-lint-langserver']},
      \ 'initialization_options': {'command': ['golangci-lint', 'run', '--config', '$XDG_CONFIG_HOME/nvim/golangci.yml', '--out-format', 'json']},
      \ 'whitelist': ['go'],
      \ })
augroup END

augroup LspRust
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'rust-analyzer',
      \ 'cmd': {server_info-> ['rust-analyzer']},
      \ 'allowlist': ['rust'],
      \ })
augroup END

augroup LspJavascript
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'javascript',
      \ 'cmd': {server_info->['javascript-typescript-stdio']},
      \ 'allowlist': ['javascript'],
      \ })
augroup END

augroup LspTypescript
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'typescript',
      \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
      \ 'args': ['--stdio'],
      \ 'allowlist': ['typescript', 'typescript.tsx'],
      \ })
augroup END

augroup LspTypescript
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'allowlist': ['python'],
      \ })
augroup END

" register ultisnips
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))

" vim-lsp shortcuts
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=auto
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    nmap <buffer> <leader>en <plug>(lsp-next-error)
    nmap <buffer> <leader>ep <plug>(lsp-previous-error)
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
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

" vim:foldmethod=marker:foldlevel=0
