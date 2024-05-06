local values = {
  -- available themes:
  --  rose-pine (variant: 'main', 'dawn', 'moon'),
  --  edge (variant: 'dark', 'aura', 'neon', 'light'),
  --  nord,
  theme = {
    name = 'rose-pine',
    variant = 'dawn',
  },
  ---@type table<string, string>
  diagnostic_signs = { Error = '󰅚', Warn = '󰀪', Info = '', Hint = '󰌶' },
  use_global_statusline = false,
  hide_command_line = false,
}

--- load custom config
local custom_file = vim.fn.stdpath('config') .. '/custom.json'
local file = io.open(custom_file, 'r')
if file then
  local content = file:read('*a')
  local cfg = vim.fn.json_decode(content)
  values = vim.tbl_deep_extend('force', values, cfg)
end

return values
