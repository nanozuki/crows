return require('packer').startup(function (use)
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- appearance
  use 'vim-airline/vim-airline'
  use 'edkolev/tmuxline.vim'
  use 'yggdroot/indentline'
  use 'tpope/vim-sleuth'

  -- colorscheme
  use 'sainnhe/gruvbox-material'
  use 'Th3Whit3Wolf/one-nvim'
  use {'sonph/onehalf', rtp = 'vim/' }
  use 'arcticicestudio/nord-vim'
  -- edit code
  use 'kshenoy/vim-signature'
  use 'scrooloose/nerdcommenter'
  use 'easymotion/vim-easymotion'
  use {
    'mg979/vim-visual-multi',
    branch = 'master',
  }
  use 'tpope/vim-surround'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  -- read code
  use 'tpope/vim-fugitive'
  use 'preservim/nerdtree'
  use 'dyng/ctrlsf.vim'
  use 'BurntSushi/ripgrep'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  -- lsp and complete
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  -- languages syntax and functions
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function () vim.cmd ':TSUpdate' end,
  }
  use 'mattn/emmet-vim'
  use 'ray-x/go.nvim'
  use 'dag/vim-fish'
end)
