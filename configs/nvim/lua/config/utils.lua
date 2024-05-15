local utils = {}

function utils.termcode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local log_file = vim.fn.stdpath('state') .. '/config.log'

function utils.log(string)
  local time = os.date('%Y-%m-%d %H:%M:%S')
  local file = io.open(log_file, 'a')
  if file then
    file:write(string.format('[%s] %s\n', time, string))
    file:close()
  else
    vim.print('Failed to open log file')
  end
end

function utils.logf(format, ...)
  utils.log(string.format(format, ...))
end

return utils
