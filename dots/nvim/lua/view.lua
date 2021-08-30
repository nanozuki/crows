local map = require("util/shim").map
local plugin = require("util/plugin")

plugin.use({
	"nvim-treesitter/nvim-treesitter",
	run = function()
		vim.cmd(":TSUpdate")
	end,
})
plugin.use("vim-airline/vim-airline")
plugin.use("edkolev/tmuxline.vim")
plugin.use("tpope/vim-fugitive")
plugin.use("preservim/nerdtree") -- use 'm' to open menu to edit filesystem nodes.

require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
})

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
