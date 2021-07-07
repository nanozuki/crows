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
  use ({'sonph/onehalf', rtp = 'vim/' })
  use 'arcticicestudio/nord-vim'
  use 'sainnhe/edge'

  -- edit code
  use 'kshenoy/vim-signature'
  use 'scrooloose/nerdcommenter'
  use 'easymotion/vim-easymotion'
  use ({'mg979/vim-visual-multi', branch = 'master'})
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
  use ({'nvim-treesitter/nvim-treesitter', run = function() vim.cmd ':TSUpdate' end})

  -- lsp and complete
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'

  -- languages extra functions
  use({'mattn/emmet-vim', ft = {'html', 'javascript.jsx', 'typescript.tsx'}})
  use({
    'ray-x/go.nvim',
    ft = {'go', 'gomod'},
    config = "require('go').setup()",
  })
  use({'dag/vim-fish', ft = {'fish'}})
end)
