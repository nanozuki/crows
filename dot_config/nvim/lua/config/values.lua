local values = {
  -- available themes:
  --  rose_pine (variant: 'main', 'dawn', 'moon'),
  --  edge (variant: 'dark', 'aura', 'neon', 'light'),
  --  nord,
  theme = {
    name = 'rose_pine',
    variant = 'dawn',
    ---@type table<string, string>
    palette = {},
  },
  languages = {
    -- default enable languages:
    vim = true,
    yaml = true,
    json = true,
    -- default disable languages:
    deno = false,
    web = false,
    go = false,
    ocaml = false,
    rust = false,
    terraform = false,
    zig = false,
    nix = false,
  },
  ---@type table<string, string>
  diagnostic_signs = { Error = '󰅚', Warn = '󰀪', Info = '', Hint = '󰌶' },
}

--- load custom config
local custom_file = vim.fn.stdpath('config') .. '/custom.json'
local file = io.open(custom_file, 'r')
if file then
  local content = file:read('*a')
  local cfg = vim.fn.json_decode(content)
  values = vim.tbl_deep_extend('force', values, cfg)
end
if vim.fn.executable('node') ~= 1 then
  values.languages.vim = false
  values.languages.yaml = false
  values.languages.json = false
end

return values
