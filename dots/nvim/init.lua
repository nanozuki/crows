-- Nanozuki Vim Config

local noremap = require("shim").noremap
local map = require("shim").map
local augroup = require("shim").augroup
local autocmd = require("shim").autocmd

--- basic & misc {{{
vim.g.mapleader = " "
vim.opt.linebreak = true
vim.opt.showbreak = "->"
vim.opt.mouse = "ar"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.modelines = 1
noremap("t", "<Esc>", [[<C-\><C-N>]])
--- }}}

--- edit {{{
vim.cmd("syntax enable")
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
-- copy selection to system clipboard
noremap("v", "<Leader>y", '"+y')
-- paste from system clipboard
noremap("n", "<Leader>p", '"+p')
-- ignore file for all
vim.cmd("set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store")
-- save as sudo
noremap("c", "w!!", "w !sudo tee %")

augroup("filetypes", {
	autocmd("BufNewFile,BufRead", "*html", "setfiletype html"),
	autocmd("BufNewFile,BufRead", "tsconfig.json", "setfiletype jsonc"),
	autocmd("BufNewFile,BufRead", "*.zig", "setfiletype zig"),
})
--- }}}

-- search & replace {{{
noremap("n", "<leader>/", ":nohlsearch<CR>")
vim.opt.ignorecase = true
-- }}}

-- indent {{{
vim.cmd("filetype indent on")
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

augroup("fileindent", {
	autocmd(
		"FileType",
		"javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json",
		"setlocal expandtab ts=2 sw=2 sts=2"
	),
})
--- }}}

require("plugins")

--- [plugin] colorscheme {{{
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
	elseif name == "onehalf" then
		if mode == "dark" then
			vim.g["airline_theme"] = "onehalfdark"
		else
			vim.g["airline_theme"] = "onehalflight"
		end
		vim.cmd("colorscheme one-nvim")
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
set_colorscheme("edge", "light")
-- }}}

--- [plugin] nvim-treesitter {{{
require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
})
--- }}}

--- [plugin] airline {{{
vim.g["airline_powerline_fonts"] = 1
vim.g["airline_extensions"] = { "tabline", "branch", "virtualenv" }
vim.g["airline#extensions#tabline#buffer_idx_mode"] = 1
for i = 0, 9 do
	map("n", "<leader>" .. i, "<Plug>AirlineSelectTab" .. i)
end
map("n", "<leader>-", "<Plug>AirlineSelectPrevTab")
map("n", "<leader>+", "<Plug>AirlineSelectNextTab")
--- }}}

--- [plugin] indentline {{{
vim.cmd("set list lcs=tab:\\¦\\ ")
vim.cmd("autocmd Filetype json let g:indentLine_enabled = 0")
--- }}}

--- [plugin] ultisnips {{{
vim.g["UltiSnipsExpandTrigger"] = "<c-e>"
vim.g["UltiSnipsJumpForwardTrigger"] = "<c-e>"
vim.g["UltiSnipsJumpBackwardTrigger"] = "<c-h>"
--- }}}

--- [plugin] nerdtree {{{
noremap("", "<Leader>fl", ":NERDTreeToggle<CR>")
vim.g["NERDTreeWinSize"] = 32
vim.g["NERDTreeWinPos"] = "left"
vim.g["NERDTreeShowHidden"] = 1
vim.g["NERDTreeMinimalUI"] = 1
vim.g["NERDTreeAutoDeleteBuffer"] = 1
vim.g["NERDTreeRespectWildIgnore"] = 1
--- }}}

--- [plugin] ctrlsf {{{
vim.g["ctrlsf_ackprg"] = "rg"
noremap("", "<leader>sf", ":CtrlSF ") -- search current name
noremap("", "<leader>sp", ":CtrlSF<CR>") -- search in project
--- }}}

--- [plugin] fzf {{{
vim.g.fzf_layout = { window = { width = 0.9, height = 0.8 } }
vim.g.fzf_colors = {
	gutter = { "bg", "Tabline" },
	["bg+"] = { "bg", "CursorLine", "CursorColumn" },
	["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
	["hl"] = { "fg", "Special" },
	["hl+"] = { "fg", "Statement" },
}
noremap("", "<C-p>", ":Files<CR>")
--- }}}

--- [plugin] ale {{{
vim.g.ale_disable_lsp = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_sign_error = "✗"
vim.g.ale_sign_warning = "‼"
local ale_config = {
	javascript = { "eslint" },
	javascriptreact = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	go = { "goimports" },
	lua = { "stylua" },
}
vim.g.ale_linters = ale_config
vim.g.ale_fixers = ale_config
--- }}}

require("lsp_settings")
require("nvim_compe")

-- vim:foldmethod=marker:foldlevel=0
