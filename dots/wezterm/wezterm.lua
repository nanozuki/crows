local wezterm = require("wezterm")

local colors = {
	foreground = "#575279",
	background = "#faf4ed",
	cursor_fg = "#575279",
	cursor_bg = "#9893a5",
	cursor_border = "#9893a5",
	selection_fg = "#575279",
	selection_bg = "#eee9e6",
	scrollbar_thumb = "#f2e9de",
	split = "#f2e9de",
	ansi = { "#f2e9de", "#b4637a", "#286983", "#ea9d34", "#56949f", "#907aa9", "#d7827e", "#575279" },
	brights = { "#6e6a86", "#b4637a", "#286983", "#ea9d34", "#56949f", "#907aa9", "#d7827e", "#575279" },
}

return {
	font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		"Menlo",
		"苹方-简",
		"Apple Color Emoji",
	}),
	use_wayland = true,
	enable_tab_bar = false,
	use_ime = true,
	colors = colors,
}
