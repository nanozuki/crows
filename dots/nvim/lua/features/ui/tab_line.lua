local feature = require("fur.feature")

local tabby_config = function()
	local palette = require("features.ui.palettes").gruvbox_light
	local filename = require("tabby.filename")
	local cwd = function()
		return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
	end
	local line = {
		hl = { fg = palette.fg, bg = palette.bg },
		layout = "active_wins_at_tail",
		head = {
			{ cwd, hl = { fg = palette.bg, bg = palette.accent } },
			{ "", hl = { fg = palette.accent, bg = palette.bg } },
		},
		active_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = palette.bg, bg = palette.accent_sec, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = palette.accent_sec, bg = palette.bg } },
			right_sep = { "", hl = { fg = palette.accent_sec, bg = palette.bg } },
		},
		inactive_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = palette.fg, bg = palette.bg_sec, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
			right_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
		},
		top_win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = { fg = palette.fg, bg = palette.bg_sec },
				}
			end,
			left_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
			right_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
		},
		win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = { fg = palette.fg, bg = palette.bg_sec },
				}
			end,
			left_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
			right_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
		},
		tail = {
			{ "", hl = { fg = palette.accent_sec, bg = palette.bg } },
			{ "  ", hl = { fg = palette.bg, bg = palette.accent_sec } },
		},
	}
	require("tabby").setup({ tabline = line })
end

local tab_line = feature:new("tab_line")
tab_line.source = "lua/features/ui/tab_line.lua"
tab_line.plugins = {
	{
		"nanozuki/tabby.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = tabby_config,
	},
}
tab_line.mappings = {
	{ "n", "<leader>ta", ":$tabnew<CR>" },
	{ "n", "<leader>tc", ":tabclose<CR>" },
	{ "n", "<leader>to", ":tabonly<CR>" },
	{ "n", "<leader>tn", ":tabn<CR>" },
	{ "n", "<leader>tp", ":tabp<CR>" },
	{ "n", "<leader>tmp", ":-tabmove<CR>" }, -- move current tab to preview position
	{ "n", "<leader>tmn", ":+tabmove<CR>" }, -- move current tab to next position
}

return tab_line
