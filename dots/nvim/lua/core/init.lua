local plug = require("lib.plug")

local core = {
	source = "lua/core/init.lua",
	features = {},
}

function core.setup(features)
	core.features = features
	for _, feature in ipairs(features) do
		feature:execute()
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
	local fs = core.features
	plug.unset()

	for _, feature in ipairs(core.features) do
		feature:reload()
	end
	core.setup(fs)
	opts = opts or {}
	if opts.action == "compile" then
		plug.compile()
	else
		plug.sync()
	end
end

return core
