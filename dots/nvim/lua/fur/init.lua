local plug = require("fur.plug")
local log = require("fur.log")

local fur = {
	features = {},
	config = {
		runtime_files = { "init.lua" },
		sync_on_reload = true,
		compile_on_reload = false,
		log_level = log.levels.error,
	},
}

function fur.setup(opts)
	for key in pairs(fur) do
		if opts[key] ~= nil then
			fur[key] = opts[key]
		end
	end
end

function fur.start()
	log.level = fur.config.log_level
	for _, feature in ipairs(fur.features) do
		feature:execute()
	end
end

function fur.plug_sync()
	require("fur.plug").sync()
end

function fur.plug_compile()
	require("fur.plug").compile()
end

function fur.reload()
	log.debug("---- RELOAD ----")
	require("fur.plug").unset()
	require("fur.feature").unset()
	for _, feature in ipairs(fur.features) do
		feature:reload()
	end
	log.debug("---- REEXECUTE ----")
	for _, file in ipairs(fur.config.runtime_files) do
		vim.cmd("runtime! " .. file)
	end
	if fur.config.sync_on_reload then
		plug.sync()
		vim.cmd("runtime! " .. require("packer").config.compile_path)
	elseif fur.config.compile_on_reload then
		plug.compile()
		vim.cmd("runtime! " .. require("packer").config.compile_path)
	end
end

return fur
