local feature = require("lib.feature")

local lang = feature:new("lang")
lang.source = "lua/lang/init.lua"
lang.setup = function()
	require("lang/go")
	require("lang/rust")
	require("lang/lua")
	require("lang/others")
end

lang.children = {
	require("lang/typescript"),
	require("lang/fish"),
}
return lang
