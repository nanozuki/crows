local feature = {
	name = nil,
	source = nil,
	children = {},

	setup = function() end,
	plugins = {},
	mappings = {},
}

function feature:new(name, o)
	o = o or {}
	o.name = name
	setmetatable(o, self)
	self.__index = self
	return o
end

local function set_map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function feature:execute()
	for _, child in ipairs(self.children) do
		child:execute()
	end

	self.setup()
	for _, plugin in ipairs(self.plugins) do
		require("lib.plug").use(plugin)
	end
	for _, mapping in ipairs(self.mappings) do
		local mode, lhs, rhs, opts = mapping[1], mapping[2], mapping[3], mapping[4]
		set_map(mode, lhs, rhs, opts)
	end
end

function feature:reload()
	for _, child in ipairs(self.children) do
		child:reload()
	end

	-- self.setup can't revert
	-- self.plugins needn't revert, will be reset by "lib.plug"
	self.setup = function() end
	self.plugins = {}
	for _, mapping in ipairs(self.mappings) do
		local mode, lhs = mapping[1], mapping[2]
		vim.api.nvim_del_keymap(mode, lhs)
	end
	self.mappings = {}

	if self.source then
		vim.cmd("source " .. self.source)
	end
end

return feature
