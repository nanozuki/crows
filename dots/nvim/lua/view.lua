local map = require("util/shim").map

require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
})

--- [plugin] airline {{{
vim.g["airline_powerline_fonts"] = 1
vim.g["airline_extensions"] = { "tabline", "branch", "virtualenv" }
vim.g["airline#extensions#tabline#buffer_idx_mode"] = 1
for i = 0, 9 do
	map("n", "<leader>" .. i, "<Plug>AirlineSelectTab" .. i, { noremap = false })
end
map("n", "<leader>-", "<Plug>AirlineSelectPrevTab", { noremap = false })
map("n", "<leader>+", "<Plug>AirlineSelectNextTab", { noremap = false })
--- }}}
