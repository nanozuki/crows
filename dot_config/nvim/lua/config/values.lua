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
  languages = {},
  use_copilot = true,
  ---@type table<string, string>
  diagnostic_signs = { Error = '󰅚', Warn = '󰀪', Info = '', Hint = '󰌶' },
}

local custom_file = vim.fn.stdpath('config') .. '/custom.json'
local file = io.open(custom_file, 'r')
if file then
  local content = file:read('*all')
  local cfg = vim.fn.json_decode(content)
  vim.print(vim.inspect(cfg))
  values = vim.tbl_deep_extend('force', values, cfg)
end

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
