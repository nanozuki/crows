local util = {}

function util.augroup(name, autocmds)
  local cmds = {
    string.format('augroup %s', name),
    'autocmd!',
  }

  for _, cmd in ipairs(autocmds) do
    table.insert(cmds, cmd)
  end

  table.insert(cmds, 'augroup end')
  local cmd_strs = table.concat(cmds, '\n')
  vim.api.nvim_exec(cmd_strs, true)
end

function util.autocmd(event, pattern, command)
  return string.format('autocmd %s %s %s', event, pattern, command)
end

function util.termcode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return util
