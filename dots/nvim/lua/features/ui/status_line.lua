local feature = require("fur.feature")

local feline_config = function()
	local palettes = {
		gruvbox_light = {
			accent = "#d65d0e", -- orange
			accent_sec = "#7c6f64", -- fg4
			bg = "#ebdbb2", -- bg1
			bg_sec = "#d5c4a1", -- bg2
			fg = "#504945", -- fg2
			fg_sec = "#665c54", -- fg3
		},
		gruvbox_dark = {
			accent = "#d65d0e", -- orange
			accent_sec = "#a89984", -- fg4
			bg = "#3c3836", -- bg1
			bg_sec = "#504945", -- bg2
			fg = "#d5c4a1", -- fg2
			fg_sec = "#bdae93", -- fg3
		},
		edge_light = {
			accent = "#bf75d6", -- bg_purple
			accent_sec = "#8790a0", -- grey
			bg = "#eef1f4", -- bg1
			bg_sec = "#dde2e7", -- bg4
			fg = "#33353f", -- default:bg1
			fg_sec = "#4b505b", -- fg
		},
		nord = {
			accent = "#88c0d0", -- nord8
			accent_sec = "#81a1c1", -- nord9
			bg = "#3b4252", -- nord1
			bg_sec = "#4c566a", -- nord3
			fg = "#e5e9f0", -- nord4
			fg_sec = "#d8dee9", -- nord4
		},
	}
	local palette = palettes.gruvbox_light
	local feline = require("feline")
	require("gitsigns").setup({ signcolumn = false })

	local left = {
		-- layer 1
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
				return " " .. mode_text[vim.fn.mode()] .. " "
			end,
			hl = { fg = "bg", bg = "accent", style = "bold" },
		},
		{
			provider = " ",
			hl = { fg = "accent", bg = "bg_sec" },
		},
		-- layer 2
		{
			provider = "file_info",
			type = "relative",
			colored_icon = false,
			file_readonly_icon = " ",
			hl = { fg = "fg", bg = "bg_sec" },
		},
		{
			provider = " ",
			hl = { fg = "bg_sec" },
		},
		-- layer 3
		{
			provider = function()
				local branch, _ = require("feline.providers.git").git_branch()
				return branch, " "
			end,
			hl = { fg = "fg_sec" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 100
			end,
		},
		{
			provider = "git_diff_added",
			hl = { fg = "fg_sec" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 120
			end,
		},
		{
			provider = "git_diff_removed",
			hl = { fg = "fg_sec" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 120
			end,
		},
		{
			provider = "git_diff_changed",
			hl = { fg = "fg_sec" },
			enabled = function(winid)
				return vim.api.nvim_win_get_width(winid) > 120
			end,
		},
	}
	local right = {
		-- layer 3
		{
			provider = function(_, winid)
				local clients = {}
				for _, client in pairs(vim.lsp.buf_get_clients(vim.api.nvim_win_get_buf(winid))) do
					clients[#clients + 1] = " " .. client.name
				end
				return table.concat(clients, " ")
			end,
			hl = { fg = "fg_sec" },
		}, -- lsp clients
		{
			provider = " ",
			hl = { fg = "bg_sec" },
		},
		-- layer 2
		{
			provider = function(_, winid)
				return " " .. vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
			end,
			hl = { fg = "fg", bg = "bg_sec" },
		},
		-- layer 1
		{
			provider = " ",
			hl = { fg = "accent_sec", bg = "bg_sec" },
		},
		{
			provider = function(_, winid)
				local row, col = unpack(vim.api.nvim_win_get_cursor(winid))
				local lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(winid))
				local text
				if row == 1 then
					text = string.format("TOP/%d:%d", lines, col)
				elseif row == lines then
					text = string.format("BOT/%d:%d", lines, col)
				else
					text = string.format("%d/%d:%d", row, lines, col)
				end
				return text .. " ", "  "
			end,
			left_sep = "",
			hl = { fg = "bg", bg = "accent_sec" },
		}, -- current lines / total lines
		{
			provider = function(_, winid)
				local bufnr = vim.api.nvim_win_get_buf(winid)
				local enc = (vim.bo[bufnr].fenc ~= "" and vim.bo[bufnr].fenc) or vim.o.enc
				return enc .. " ", " "
			end,
			hl = { fg = "bg", bg = "accent_sec" },
		},
	}
	local in_left = {
		{
			provider = "█ ",
			hl = { fg = "accent", bg = "bg" },
		},
		{
			provider = "file_info",
			type = "relative",
			file_readonly_icon = " ",
			colored_icon = false,
			hl = { fg = "fg", bg = "bg" },
		},
	}
	local in_right = {
		{
			provider = " █",
			hl = { fg = "accent_sec", bg = "bg" },
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
