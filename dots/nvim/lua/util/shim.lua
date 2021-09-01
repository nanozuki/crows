local M = {}

function M.map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.augroup(name, autocmds)
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

function M.autocmd(event, pattern, command)
	return string.format("autocmd %s %s %s", event, pattern, command)
end

function M.vim_kv_args(args)
	local arg_strs = {}
	for key, arg in pairs(args) do
		table.insert(arg_strs, string.format("%s=%s", key, arg))
	end
	return table.concat(arg_strs, " ")
end

function M.termcode(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.prequire(pkg, fn)
	local ok, result = pcall(require, pkg)
	if ok then
		fn(result)
	else
		print("can't load pkg: " .. pkg)
	end
end

return M
