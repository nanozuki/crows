local feature = require("fur.feature")
local packadd = require("fur").packadd

local ui = feature:new("ui")
ui.source = "lua/features/ui.lua"

local treesitter = feature:new("treesitter")
treesitter.plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "maintained",
				highlight = { enable = true },
			})
		end,
	},
}

local buffer_line = feature:new("buffer_line")
buffer_line.plugins = {
	{
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
}

local filetree = feature:new("filetree")
filetree.setup = function()
	vim.g.nvim_tree_lsp_diagnostics = 1
end
filetree.plugins = {
	{
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-tree.view").View.winopts.signcolumn = "auto"
		end,
	},
}
filetree.mappings = {
	{ "n", "<Leader>fl", ":NvimTreeToggle<CR>" },
}

local colorscheme = feature:new("colorscheme")
colorscheme.plugins = {
	{ "sainnhe/gruvbox-material", opt = true },
	{ "arcticicestudio/nord-vim", opt = true },
	{ "sainnhe/edge", opt = true },
}
local colorschemes = {
	gruvbox_light = function()
		if packadd("gruvbox-material") then
			vim.opt.background = "light"
			vim.g["gruvbox_material_enable_italic"] = 1
			vim.g["airline_theme"] = "gruvbox_material"
			vim.cmd("colorscheme gruvbox-material")
		end
	end,
	gruvbox_dark = function()
		if packadd("gruvbox-material") then
			vim.opt.background = "dark"
			vim.g["gruvbox_material_enable_italic"] = 1
			vim.g["airline_theme"] = "gruvbox_material"
			vim.cmd("colorscheme gruvbox-material")
		end
	end,
	nord = function()
		if packadd("nord-vim") then
			vim.g["airline_theme"] = "nord"
			vim.cmd("colorscheme nord")
		end
	end,
	edge_light = function()
		if packadd("edge") then
			vim.opt.background = "light"
			vim.g.edge_enable_italic = 1
			vim.g.airline_theme = "edge"
			vim.cmd("colorscheme edge")
		end
	end,
}
colorscheme.setup = function()
	vim.opt.termguicolors = true -- true color
	local function set_colorscheme(name)
		colorschemes[name]()
	end
	set_colorscheme("edge_light")
end

local tmuxline = feature:new("tmuxline")
tmuxline.plugins = {
	{ "edkolev/tmuxline.vim", opt = true },
}
tmuxline.setup = function()
	function Tmuxline(mode)
		vim.cmd("packadd tmuxline.vim")
		if mode == "insert" then
			vim.cmd("Tmuxline airline_insert")
		elseif mode == "visual" then
			vim.cmd("Tmuxline airline_visual")
		else
			vim.cmd("Tmuxline airline")
		end
	end
	function TmuxlineSnapshot(file)
		vim.cmd("packadd tmuxline.vim")
		vim.cmd("TmuxlineSnapshot " .. file)
	end
end

ui.children = {
	colorscheme,
	treesitter,
	require("features.ui.status_line"),
	buffer_line,
	filetree,
	tmuxline,
}

return ui
