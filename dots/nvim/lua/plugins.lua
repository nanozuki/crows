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
Plug 'BurntSushi/ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" lsp and complete
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" languages syntax and functions
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mattn/emmet-vim'
Plug 'ray-x/go.nvim'
Plug 'buoto/gotests-vim', { 'for': 'go' }
Plug 'dag/vim-fish'

""" Initialize plugin system
call plug#end()
]]
, true)
