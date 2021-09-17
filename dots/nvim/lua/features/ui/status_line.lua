local feature = require("fur.feature")

local feline_config = function()
	local palette = require("lib.colors").palettes.gruvbox_light
	local feline = require("feline")
	require("gitsigns").setup({ signcolumn = false })

	local left = {
		{
			provider = "█",
			hl = { fg = "orange" },
			right_sep = " ",
		},
		{
			provider = function()
				local mode_text = {
					n = "NORMAL",
					v = "VISUAL",
					V = "V-LINE",
					s = "SELECT",
					S = "S-LINE",
					[string.char(19)] = "V-BLOCK", -- CTRL-S
					i = "INSERT",
					[string.char(22)] = "S-BLOCK", -- CTRL-V
					R = "REPLACE",
					c = "COMMAND",
					r = "PROMPT",
					["!"] = "SHELL",
					t = "TERMINAL",
				}
				return mode_text[vim.fn.mode()]
			end,
			hl = { fg = "orange" },
			right_sep = " ",
		},
		{
			provider = "file_type",
			right_sep = " ",
			hl = { fg = "magenta" },
		},
		{
			provider = "file_info",
			right_sep = " ",
			hl = { fg = "magenta" },
			type = "relative",
			file_readonly_icon = " ",
		},
		{
			provider = function()
				local branch, _ = require("feline.providers.git").git_branch()
				return branch, " "
			end,
			hl = { fg = "orange" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 100
			end,
		},
		{
			provider = "git_diff_added",
			hl = { fg = "green" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 120
			end,
		},
		{
			provider = "git_diff_removed",
			hl = { fg = "red" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 120
			end,
		},
		{
			provider = "git_diff_changed",
			hl = { fg = "blue" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 120
			end,
		},
	}
	local right = {
		{
			provider = function(_, winid)
				local clients = {}
				for _, client in pairs(vim.lsp.buf_get_clients(vim.api.nvim_win_get_buf(winid))) do
					clients[#clients + 1] = " " .. client.name
				end
				return table.concat(clients, " ")
			end,
			hl = { fg = "magenta" },
		}, -- lsp clients
		{
			provider = function(_, winid)
				return string.format("%d:%d", unpack(vim.api.nvim_win_get_cursor(winid)))
			end,
			left_sep = " ",
			hl = { fg = "grey" },
		}, -- position
		{
			left_sep = " ",
			provider = function(_, winid)
				local curr_line = vim.api.nvim_win_get_cursor(winid)[1]
				local lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(winid))
				if curr_line == 1 then
					return "Top"
				elseif curr_line == lines then
					return "Bot"
				else
					return string.format("%d/%d", curr_line, lines)
				end
			end,
			hl = { fg = "grey" },
		}, -- current lines / total lines
		{
			provider = "file_encoding",
			left_sep = " ",
		},
		{
			provider = "█",
			hl = { fg = "bg1" },
			left_sep = " ",
		},
	}
	local in_left = {
		{
			provider = "█",
			hl = { fg = "orange" },
			right_sep = " ",
		},
		{
			provider = "file_info",
			type = "relative-short",
			file_readonly_icon = " ",
			hl = { fg = "magenta" },
		},
	}
	local in_right = {
		{
			provider = "█",
			hl = { fg = "grey" },
		},
	}

	feline.setup({
		colors = palette,
		components = {
			active = { left, right },
			inactive = { in_left, in_right },
		},
		force_inactive = { filetypes = { "NvimTree", "help" }, buftypes = { "terminal" }, bufnames = {} },
	})
end

local status_line = feature:new("status_line")
status_line.source = "lua/features/ui/status_line.lua"
status_line.plugins = {
	{
		"famiu/feline.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			"lewis6991/gitsigns.nvim",
		},
		config = feline_config,
	},
}

return status_line
