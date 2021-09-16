local feature = require("fur.feature")

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

local airline = feature:new("airline")
airline.plugins = {
	"vim-airline/vim-airline",
}
airline.setup = function()
	vim.g["airline_powerline_fonts"] = 1
	vim.g["airline_extensions"] = { "tabline", "branch", "virtualenv" }
	vim.g["airline#extensions#tabline#buffer_idx_mode"] = 1
end
airline.mappings = {
	{ "n", "<leader>-", "<Plug>AirlineSelectPrevTab", { noremap = false } },
	{ "n", "<leader>+", "<Plug>AirlineSelectNextTab", { noremap = false } },
}
for i = 0, 9 do
	airline.mappings[#airline.mappings + 1] = {
		"n",
		"<leader>" .. i,
		"<Plug>AirlineSelectTab" .. i,
		{ noremap = false },
	}
end

local filetree = feature:new("filetree")
filetree.plugins = {
	"preservim/nerdtree", -- use 'm' to open menu to edit filesystem nodes.
}
filetree.setup = function()
	vim.g.NERDTreeWinSize = 32
	vim.g.NERDTreeWinPos = "left"
	vim.g.NERDTreeShowHidden = 1
	vim.g.NERDTreeMinimalUI = 1
	vim.g.NERDTreeAutoDeleteBuffer = 1
	vim.g.NERDTreeRespectWildIgnore = 1
end
filetree.mappings = {
	{ "n", "<Leader>fl", ":NERDTreeToggle<CR>" },
}

local colorscheme = feature:new("colorscheme")
colorscheme.plugins = {
	{ "sainnhe/gruvbox-material", opt = true },
	{ "arcticicestudio/nord-vim", opt = true },
	{ "sainnhe/edge", opt = true },
}
local colorschemes = {
	gruvbox_light = function()
		vim.cmd("packadd gruvbox-material")
		vim.opt.background = "light"
		vim.g["gruvbox_material_enable_italic"] = 1
		vim.g["airline_theme"] = "gruvbox_material"
		vim.cmd("colorscheme gruvbox-material")
	end,
	gruvbox_dark = function()
		vim.cmd("packadd gruvbox-material")
		vim.opt.background = "dark"
		vim.g["gruvbox_material_enable_italic"] = 1
		vim.g["airline_theme"] = "gruvbox_material"
		vim.cmd("colorscheme gruvbox-material")
	end,
	nord = function()
		vim.cmd("packadd nord-vim")
		vim.g["airline_theme"] = "nord"
		vim.cmd("colorscheme nord")
	end,
	edge_light = function()
		vim.cmd("packadd edge")
		vim.g["edge_enable_italic"] = 1
		vim.g["airline_theme"] = "edge"
		vim.cmd("colorscheme edge")
	end,
}
colorscheme.setup = function()
	vim.opt.termguicolors = true -- true color
	local function set_colorscheme(name)
		colorschemes[name]()
	end
	set_colorscheme("gruvbox_light")
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
	treesitter,
	airline,
	filetree,
	colorscheme,
	tmuxline,
}

return ui
