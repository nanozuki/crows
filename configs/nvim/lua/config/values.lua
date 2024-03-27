local values = {
  -- available themes:
  --  rose-pine (variant: 'main', 'dawn', 'moon'),
  --  edge (variant: 'dark', 'aura', 'neon', 'light'),
  --  nord,
  theme = {
    name = 'rose-pine',
    variant = 'dawn',
  },
  languages = {
    -- builtin languages:
    lua = true,
    -- default enable languages:
    vim = true,
    json = true,
    yaml = true,
    -- default disable languages:
    go = false,
    nix = false,
    ocaml = false,
    rust = false,
    svelte = false,
    terraform = false,
    typescript_deno = false,
    typescript_node = false,
    zig = false,
  },
  ---@type table<string, string>
  diagnostic_signs = { Error = '󰅙', Warn = '', Info = '󰌵', Hint = '' },
  use_global_statusline = false,
  use_noice = false,
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
