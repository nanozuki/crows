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
    built_in = { 'lua', 'viml', 'json', 'yaml', 'markdown' },
    optional = {
      go = vim.fn.executable('gopls') == 1,
      ocaml = vim.fn.executable('ocamllsp') == 1,
      rust = vim.fn.executable('rust-analyzer') == 1,
      typescript = vim.fn.executable('tsserver') == 1,
      terraform = vim.fn.executable('terraform-ls') == 1,
      zig = vim.fn.executable('zls') == 1,
    },
  },
  use_copilot = true,
  ---@type table<string, string>
  diagnostic_signs = { Error = '󰅚', Warn = '󰀪', Info = '', Hint = '󰌶' },
}

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
