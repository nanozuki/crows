return require('packer').startup(function (use)
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- appearance
  use 'vim-airline/vim-airline'
  use 'edkolev/tmuxline.vim'
  use 'yggdroot/indentline'
  use 'tpope/vim-sleuth' -- smart detect indent of file

  -- colorscheme
  use 'sainnhe/gruvbox-material'
  use 'Th3Whit3Wolf/one-nvim'
  use ({'sonph/onehalf', rtp = 'vim/' })
  use 'arcticicestudio/nord-vim'
  use 'sainnhe/edge'

  -- edit code
  use 'kshenoy/vim-signature'
  use 'scrooloose/nerdcommenter' -- <leader>ci (toggle comment), <leader>cs (comment block), <leader>cu (uncomment)
  use 'easymotion/vim-easymotion'
  use ({'mg979/vim-visual-multi', branch = 'master'}) -- Ctrl-N: start, n: next, q: skip, Q: remove current
  use 'tpope/vim-surround' -- cs"': "a"->'a', ysiw]: word->[word], cs]{: [word]->{ word }
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'

  -- read code
  use 'tpope/vim-fugitive'
  use 'preservim/nerdtree' -- use 'm' to open menu to edit filesystem nodes.
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
