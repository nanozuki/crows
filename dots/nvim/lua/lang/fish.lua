local feature = require("fur.feature")

local fish = feature:new("lang.fish")
fish.source = "lua/lang/fish.lua"
fish.plugins = {
	{
		"dag/vim-fish",
		ft = { "fish" },
	},
}

return fish
