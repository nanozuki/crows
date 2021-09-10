local map = require("util/shim").map

local search = {
	plugins = {},
}

map("n", "<leader>/", ":nohlsearch<CR>")
vim.opt.ignorecase = true

--- [plugin] ctrlsf {{{
search.plugins.ctrlsf = {
	"dyng/ctrlsf.vim",
	requires = {
		{ "BurntSushi/ripgrep" },
	},
	config = function()
		vim.g.ctrlsf_ackprg = "rg"
	end,
}
map("", "<leader>sf", ":CtrlSF ") -- search current name
map("", "<leader>sp", ":CtrlSF<CR>") -- search in project
--- }}}

--- [plugin] telescope {{{
search.plugins.telescope = {
	"nvim-telescope/telescope.nvim",
	requires = {
		{ "nvim-telescope/telescope-z.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
	},
	config = function()
		require("telescope").load_extension("z")
		require("telescope").load_extension("fzf")
		require("telescope").setup({
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
		})
	end,
}

print("mapping")
map("n", "<leader>z", "<cmd>lua require'telescope'.extensions.z.list{}<CR>", { silent = true })
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<C-P>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
map("n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>")
map("n", "<leader>ft", "<cmd>lua require('telescope.builtin').treesitter()<cr>")
print("mapping ending")
--- }}}

return search
