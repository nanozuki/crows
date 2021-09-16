local util = {}

function util.augroup(name, autocmds)
	local cmds = {
		string.format("augroup %s", name),
		"autocmd!",
	}

	for _, cmd in ipairs(autocmds) do
		-- table.insert(cmds, M.autocmd(cmd))
		table.insert(cmds, cmd)
	end

	table.insert(cmds, "augroup end")
	local cmd_strs = table.concat(cmds, "\n")
	vim.api.nvim_exec(cmd_strs, true)
end

function util.autocmd(event, pattern, command)
	return string.format("autocmd %s %s %s", event, pattern, command)
end

function util.vim_kv_args(args)
	local arg_strs = {}
	for key, arg in pairs(args) do
		table.insert(arg_strs, string.format("%s=%s", key, arg))
	end
	return table.concat(arg_strs, " ")
end

function util.termcode(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function util.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

return util
