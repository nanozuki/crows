vim.opt.termguicolors = true
local function set_colorscheme(name, mode)
	if mode == "dark" then
		vim.opt.background = "dark"
	else
		vim.opt.background = "light"
	end

	if name == "gruvbox" then
		vim.g["gruvbox_material_enable_italic"] = 1
		vim.g["airline_theme"] = "gruvbox_material"
		vim.cmd("colorscheme gruvbox-material")
	elseif name == "nord" then
		vim.g["airline_theme"] = "nord"
		vim.cmd("colorscheme nord")
	elseif name == "edge" then
		-- vim.g['edge_style'] = 'aura'
		vim.g["edge_enable_italic"] = 1
		vim.g["airline_theme"] = "edge"
		vim.cmd("colorscheme edge")
	end
	return
end
set_colorscheme("gruvbox", "light")
