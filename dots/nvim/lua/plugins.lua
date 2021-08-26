-- auto install paq-nvim if not exist
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", install_path })
end

require("paq")({
	-- paq-nvim itself
	"savq/paq-nvim",

	-- appearance
	"vim-airline/vim-airline",
	"edkolev/tmuxline.vim",
	"yggdroot/indentline",
	"tpope/vim-sleuth", -- smart detect indent of file

	-- colorscheme
	"sainnhe/gruvbox-material",
	"Th3Whit3Wolf/one-nvim",
	-- ({'sonph/onehalf', rtp = 'vim/' }),
	"arcticicestudio/nord-vim",
	"sainnhe/edge",

	-- edit code
	"kshenoy/vim-signature",
	"scrooloose/nerdcommenter", -- <leader>ci (toggle comment), <leader>cs (comment block), <leader>cu (uncomment)
	"easymotion/vim-easymotion",
	"mg979/vim-visual-multi",
	"tpope/vim-surround", -- cs"': "a"->'a', ysiw]: word->[word], cs]{: [word]->{ word }
	"SirVer/ultisnips",
	"honza/vim-snippets",
	"dense-analysis/ale",

	-- read code
	"tpope/vim-fugitive",
	"preservim/nerdtree", -- use 'm' to open menu to edit filesystem nodes.
	"dyng/ctrlsf.vim",
	"BurntSushi/ripgrep",
	"junegunn/fzf",
	"junegunn/fzf.vim",
	{
		"nvim-treesitter/nvim-treesitter",
		run = function()
			vim.cmd(":TSUpdate")
		end,
	},

	-- lsp and complete
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-compe",

	-- languages extra functions
	"mattn/emmet-vim", -- ft = {'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact'}})
	"dag/vim-fish", -- ft = {'fish'}})
})
