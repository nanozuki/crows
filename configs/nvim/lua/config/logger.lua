local M = {}

local log_file = vim.fn.stdpath('state') .. '/config.log'

function M.log(string)
  local time = os.date('%Y-%m-%d %H:%M:%S')
  local file = io.open(log_file, 'a')
  if file then
    file:write(string.format('[%s] %s\n', time, string))
    file:close()
  else
    vim.print('Failed to open log file')
  end
end

function M.logf(format, ...)
  M.log(string.format(format, ...))
end

return M
