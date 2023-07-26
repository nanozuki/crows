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
    vim = true,
    yaml = true,
    json = true,
    go = false,
    rust = false,
    frontend = false,
    deno = false,
    ocaml = false,
    terraform = false,
    zig = false,
  },
  use_null_ls = false,
  use_copilot = true,
  ---@type table<string, string>
  diagnostic_signs = { Error = '󰅚', Warn = '󰀪', Info = '', Hint = '󰌶' },
}

local custom_file = vim.fn.stdpath('config') .. '/custom.json'
local file = io.open(custom_file, 'r')
if file then
  local content = file:read('*a')
  local cfg = vim.fn.json_decode(content)
  values = vim.tbl_deep_extend('force', values, cfg)
end

---@type table<string, string[]>
values.formatter_filetypes = {
  stylua = { 'lua' },
  prettier = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'css',
    'scss',
    'less',
    'html',
    'json',
    'jsonc',
    'yaml',
    'markdown',
    'markdown.mdx',
    'graphql',
    'handlebars',
  },
  goimports = { 'go' },
}

---@type table<string, string[]>
values.linter_filetypes = {
  eslint_d = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  },
  ['golangci-lint'] = { 'go' },
}

return values
