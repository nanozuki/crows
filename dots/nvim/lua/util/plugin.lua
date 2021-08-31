--- auto install packer {{{
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd("packadd packer.nvim")
end
--- }}}

--- plugins {{{
return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	-- basic lua library extension
	use("nvim-lua/plenary.nvim")
	-- key mapping
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})

	-- colorscheme.lua
	use("sainnhe/gruvbox-material")
	use("Th3Whit3Wolf/one-nvim")
	use("arcticicestudio/nord-vim")
	use("sainnhe/edge")

	-- indent.lua
	use("yggdroot/indentline") -- display hint for indent
	use("tpope/vim-sleuth") -- smart detect indent of file

	-- view.lua
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("vim-airline/vim-airline")
	use("edkolev/tmuxline.vim")
	use("tpope/vim-fugitive")
	use("preservim/nerdtree") -- use 'm' to open menu to edit filesystem nodes.

	-- edit.lua
	use("kshenoy/vim-signature")
	use("scrooloose/nerdcommenter") -- <leader>ci (toggle comment), <leader>cs (comment block), <leader>cu (uncomment)
	use("easymotion/vim-easymotion")
	use("mg979/vim-visual-multi")
	use("tpope/vim-surround") -- cs"': "a"->'a', ysiw]: word->[word], cs]{: [word]->{ word }
	use("dense-analysis/ale")

	-- search.lua
	use("dyng/ctrlsf.vim")
	use("BurntSushi/ripgrep")
	use("nvim-telescope/telescope.nvim")

	-- util/lsp
	use("neovim/nvim-lspconfig")
	use("ray-x/lsp_signature.nvim")
	use("RishabhRD/popfix")
	use("RishabhRD/nvim-lsputils")

	-- complete.lua
	use("hrsh7th/nvim-compe")
	use("hrsh7th/vim-vsnip")

	-- languages extra functions
	use("mattn/emmet-vim") -- ft = {'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact'}})
	use("dag/vim-fish") -- ft = {'fish'}})
end)
--- }}}
