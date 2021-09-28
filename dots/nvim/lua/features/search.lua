local feature = require("fur.feature")

local search = feature:new("search")
search.source = "lua/features/search.lua"
search.setup = function()
	vim.opt.ignorecase = true
end
search.mappings = {
	{ "n", "<leader>/", ":nohlsearch<CR>" },
}

local replace = feature:new("replace")
replace.plugins = {
	{
		"dyng/ctrlsf.vim",
		config = function()
			vim.g.ctrlsf_ackprg = "rg"
		end,
	},
}
replace.mappings = {
	{ "n", "<leader>sf", ":CtrlSF " },
	{ "n", "<leader>sp", ":CtrlSF<CR>" },
}

local telescope = feature:new("telescope")
telescope.plugins = {
	{
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
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
	},
}
telescope.mappings = {
	{ "n", "<leader>z", "<cmd>lua require'telescope'.extensions.z.list{}<CR>", { silent = true } },
	{ "n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>" },
	{ "n", "<C-P>", "<cmd>lua require('telescope.builtin').find_files()<cr>" },
	{ "n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>" },
	{ "n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>" },
	{ "n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" },
	{ "n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>" },
	{ "n", "<leader>ft", "<cmd>lua require('telescope.builtin').treesitter()<cr>" },
}

search.children = { replace, telescope }
return search
