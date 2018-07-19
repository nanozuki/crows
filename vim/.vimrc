"=======================
"|                     |
"|      基本设置       |
"|                     |
"=======================

"" 语言和编码
let $LANG="zh_CN.UTF-8"
set langmenu=zh_cn.utf-8
set encoding=utf8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8

"" 快捷键前缀
let mapleader=";"

"" 基本设置
filetype on
filetype plugin on
set backspace=2
set backspace=indent,eol,start
set mouse=a

"" 提高性能
set ttyfast

"" 窗口
nmap <Leader>q :q<CR>
nmap <Leader>w :w<CR>
nmap <Leader>WQ :wa<CR>:q<CR>
nmap <Leader>Q :qa!<CR>
" 依次遍历子窗口（next window)
nnoremap nw <C-W><C-W>
" 跳转至右方的窗口
nnoremap <Leader>lw <C-W>l
" 跳转至方的窗口
nnoremap <Leader>hw <C-W>h
" 跳转至上方的子窗口
nnoremap <Leader>kw <C-W>k
" 跳转至下方的子窗口
nnoremap <Leader>jw <C-W>j
" 定义快捷键在结对符之间跳转，助记pair
nmap <Leader>pa %

"" 自定义命令与功能
" 设置环境保存项
set sessionoptions="blank,buffers,globals,localoptions,tabpages,sesdir,folds,help,options,resize,winpos,winsize"
" 保存环境
map <leader>ss :mksession! my.vim<cr> :wviminfo! my.viminfo<cr>
" 恢复环境
map <leader>rs :source my.vim<cr> :rviminfo my.viminfo<cr>

"=======================
"|                     |
"|        外观         |
"|                     |
"=======================
" 去掉菜单栏和工具栏
set guioptions-=m
set guioptions-=T
" 去掉滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" 主题
" true color support
set termguicolors
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set background=dark
" colorscheme solarized
" colorscheme Tomorrow-Night
colorscheme gruvbox
let g:gruvbox_italic=1
" 状态栏
let g:airline_theme="gruvbox"
let g:airline_powerline_fonts=1
let g:airline_extensions=['tabline', 'branch', 'virtualenv']

"" 显示设置
set number
" 相对行号
set relativenumber
set ruler
" set cursorline   "定位当前行
" set cursorcolumn "定位当前列
set hlsearch       "高亮搜索结果
set laststatus=2   "总是显示状态栏
set colorcolumn=80 "每行不超过80字符

"=======================
"|                     |
"|   通用文件编辑      |
"|                     |
"=======================

"" 定义快捷键到行首和行尾
nmap <Leader>lb 0
nmap <Leader>le $
" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪贴板内容粘贴至vim
nmap <Leader>p "+p

"" 开启实时搜索功能
set incsearch
" 搜索时大小写不敏感
set ignorecase
" 关闭兼容模式
set nocompatible
" vim 自身命令行模式智能补全
set wildmenu

"" BUFFER管理器 ([plugin]airline#tabline)
" let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#tabline#buffer_nr_show=1

"" 查找与替换
" 查找 ([Plugin]ctrlsf)
let g:ctrlsf_ackprg = 'rg'
nmap <leader>sf :CtrlSF 
nmap <leader>sp :CtrlSF<CR>
" 替换 ([Plugin]vim-multiple-cursors)
" <C-n> 选中更多

" 关闭语法隐藏([Plugin]indentLint)
let g:indentLine_conceallevel=0

"" 忽略文件 (也能设置到 [Plugin]ctrlP 上)
:set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,

"" save as sudo
cmap w!! w !sudo tee %

"======================m
"|                     |
"|   代码阅读:通用     |
"|                     |
"=======================

"" 代码高亮
syntax enable
syntax on
" 括号匹配（必须放在 syntax 的后面，否则无效)
highlight MatchParen ctermbg=darkmagenta ctermfg=white

"" 文档标记([Plugin]vim-signature)
" m{a-zA-Z} 设置/取消标记, 大写为全局标记
" `{a-zA-Z} 调到对应的标记
" 跳转到自动标记:
"     ``  上次跳转的位置
"     `.  上次修改的位置
"     `^  上次插入的位置
"     `[  字母顺序的下一个标签
"     `]  字母顺序的上一个标签
"     `<  上次选区的起始位置
"     `>  上次选区的结束位置

"" 代码折叠 基于缩进或者语法
set foldmethod=indent
set foldlevel=999
"set foldmethod=syntax
" 操作说明：
" zo[O] [嵌套地]打开折叠
" zc[C] [嵌套地]关闭折叠
" za[A] [嵌套地]打开/关闭折叠
" zm    全部折叠增加一级 
" zM    关闭全部折叠
" zr    全部折叠减少一级
" zR    打开全部折叠

"" 代码缩进提示([Plugin]indentline)
" let g:indentLine_enabled=1
set list lcs=tab:\¦\ 

"" 文件列表窗口([plugin]NERDTree)
" 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
nmap <Leader>fl :NERDTreeToggle<CR>
" 设置NERDTree子窗口宽度
let NERDTreeWinSize=32
" 设置NERDTree子窗口位置
let NERDTreeWinPos="left"
" 显示隐藏文件
let NERDTreeShowHidden=1
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1

"=======================
"|                     |
"|   代码编写:通用     |
"|                     |
"=======================

"" 缩进
filetype indent on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" 某些文件类型的特别缩进
autocmd BufRead,BufNewFile *html setfiletype html
autocmd FileType javascript setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType html setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType css setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType scss setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType xml setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType json setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType wxss setlocal expandtab ts=2 sw=2 sts=2
autocmd FileType wxml setlocal expandtab ts=2 sw=2 sts=2

"" 快速开关注释 ([Plugin]NERD Commenter)
" 操作方式
" {number}<leader>cc 注释文本
" {number}<leader>cu 取消注释文本

"" 智能提示 ([Plugin]YCM)
" 只能是 #include 或已打开的文件
nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_confirm_extra_conf=0
" 补全内容不以分割子窗口形式出现，只显示补全列表
set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全         
let g:ycm_seed_identifiers_with_syntax=1
" ale提示 ([Plugin]ale)
let g:ale_completion_enabled = 1

" 模板补全 ([Plugin]UltiSnips)
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"

" 语法检查, 自动修正 ([Plugin]ale)
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}
let g:ale_fix_on_save = 1

"=======================
"|                     |
"|   代码编写:Python   |
"|                     |
"=======================

" PEP8_检查([Plugin] flake8)
autocmd FileType python map <leader>pf :call Flake8()<CR>
autocmd BufWritePost *.py call Flake8()
let g:flake8_show_in_gutter=1
let g:flake8_show_quickfix=0

" set ycmd
let g:ycm_server_python_interpreter="python3"

"python virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(compile(open(activate_this, 'rb').read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"=======================
"|                     |
"|   代码编写:前端     |
"|                     |
"=======================

" vim-jsx:
let g:jsx_ext_required = 0
" 修改ycm补全css的触发条件
let g:ycm_semantic_triggers = {
\ 'css': [ 're!^\s{2,}', 're!:\s+'], 'html': [ '</' ],
\ 'scss': [ 're!^\s{2,}', 're!:\s+'], 'js': [ '</' ],
\}

"=======================
"|                     |
"|   代码编写:Go       |
"|                     |
"=======================
" vim-go
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

"=======================
"|                     |
"|      插件管理       |
"|                     |
"=======================
" vim-plug
" Specify a directory for plugins
call plug#begin('~/.vim/plugins')

" 外观
Plug 'vim-airline/vim-airline'          " 状态栏强化
Plug 'vim-airline/vim-airline-themes'   " 状态栏主题
Plug 'yggdroot/indentline'              " 提示缩进 
Plug 'morhetz/gruvbox'
" 通用编辑
Plug 'w0rp/ale'                      " 语法检查
Plug 'kshenoy/vim-signature'         " 代码书签显示
Plug 'scrooloose/nerdcommenter'      " 开关注释
Plug 'easymotion/vim-easymotion'     " 快速跳转
Plug 'tpope/vim-fugitive'            " git信息显示
Plug 'terryma/vim-multiple-cursors'  " 多重编辑
" 代码查看
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " 文件列表
Plug 'dyng/ctrlsf.vim'        " 工程内搜索
Plug 'kien/ctrlp.vim'         " 工程内搜索文件
Plug 'BurntSushi/ripgrep'     " ctrlsf的后端
" 代码补全
Plug 'Valloric/YouCompleteMe'     " ycm
Plug 'SirVer/ultisnips'           " 模板补全
Plug 'CrowsT/vim-snippets'        " 自定义模板
" 特定编程语言
" python
Plug 'nvie/vim-flake8', { 'for': 'python' } " PEP8代码风格检查
" Javascript/React
Plug 'pangloss/vim-javascript', { 'for': 'javascript' } "syntax
Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
Plug 'mattn/emmet-vim', { 'for': ['javascript', 'html'] }  "emmet
Plug 'mxw/vim-jsx', { 'for': 'javascript' }  " React
" Go
Plug 'fatih/vim-go', { 'for': 'go' } " golang
Plug 'buoto/gotests-vim', { 'for': 'go' } "gotests

""" Initialize plugin system
call plug#end()
