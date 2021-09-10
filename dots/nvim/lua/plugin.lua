--- auto install packer {{{
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd("packadd packer.nvim")
end
--- }}}

local plugin_spec_file = "lua/plugin.lua"

function PackerSync()
	local path = vim.api.nvim_get_runtime_file(plugin_spec_file, false)[1]
	if not path then
		error("can't find plugin setup file")
	end
	require("packer").reset()
	vim.cmd("source " .. path)
	require("packer").sync()
end

function PackerCompile()
	local path = vim.api.nvim_get_runtime_file(plugin_spec_file, false)[1]
	if not path then
		error("can't find plugin setup file")
	end
	require("packer").reset()
	vim.cmd("source " .. path)
	require("packer").compile()
end

--- plugins {{{
return require("packer").startup({
	function(use)
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
		use({ "sainnhe/gruvbox-material", opt = true })
		use({ "arcticicestudio/nord-vim", opt = true })
		use({ "sainnhe/edge", opt = true })

		-- indent.lua
		use("yggdroot/indentline") -- display hint for indent
		use("tpope/vim-sleuth") -- smart detect indent of file

		-- view.lua
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
		})
		use("vim-airline/vim-airline")
		use({ "edkolev/tmuxline.vim", opt = true })
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
		use(require("search").plugins.ctrlsf)
		use(require("search").plugins.telescope)

		-- util/lsp
		use("neovim/nvim-lspconfig")
		use("ray-x/lsp_signature.nvim")
		use({
			"RishabhRD/nvim-lsputils",
			requires = { { "RishabhRD/popfix" } },
		})
		use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })

		-- complete.lua
		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/vim-vsnip",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		})

		-- languages extra functions
		use({
			"mattn/emmet-vim",
			ft = { "html", "javascript.jsx", "typescript.tsx", "javascriptreact", "typescriptreact" },
		})
		use({
			"dag/vim-fish",
			ft = { "fish" },
		})
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})
--- }}}
