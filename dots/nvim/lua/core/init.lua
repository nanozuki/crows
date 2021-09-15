local plug = require("lib.plug")
local log = require("lib.log")

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
	require("lib.plug").sync()
end

function core.plug_compile()
	require("lib.plug").compile()
end

function core.unset()
	for _, feature in ipairs(core.features) do
		feature:unset()
	end
	core.features = {}
end

function core.reload(opts)
	log.debug("---- RELOAD ----")
	require("lib.plug").unset()
	require("lib.feature").unset()
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

function ReloadFeatures()
	core.reload()
end

function PackerSync()
	plug.sync()
end

function PackerCompile()
	plug.compile()
end

return core
