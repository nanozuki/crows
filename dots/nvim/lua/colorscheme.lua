vim.opt.termguicolors = true

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

local function set_colorscheme(name)
	colorschemes[name]()
end

set_colorscheme("gruvbox_light")
