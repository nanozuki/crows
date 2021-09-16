local plug = require("fur.plug")
local log = require("fur.log")

local core = {
	source = "lua/core/init.lua",
	features = {},
}

function core.setup()
	for _, feature in ipairs(core.features) do
		feature:execute()
		-- feature:execute()
	end
end

function core.plug_sync()
	require("fur.plug").sync()
end

function core.plug_compile()
	require("fur.plug").compile()
end

function core.unset()
	for _, feature in ipairs(core.features) do
		feature:unset()
	end
	core.features = {}
end

function core.reload(opts)
	log.debug("---- RELOAD ----")
	require("fur.plug").unset()
	require("fur.feature").unset()
	for _, feature in ipairs(core.features) do
		feature:reload()
	end
	log.debug("---- REEXECUTE ----")
	vim.cmd("runtime! init.lua")
	opts = opts or {}
	if opts.action == "compile" then
		plug.compile()
	else
		plug.sync()
	end
end

return core
