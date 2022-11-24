-- built-in languages
local packages = { 'lua-language-server', 'stylua', 'vim-language-server', 'yaml-language-server' }

-- opt languages
local opt_languages = require('config.custom').opt_languages
if opt_languages.go then
  vim.list_extend(packages, {
    'gopls',
    'golangci-lint',
    'golangci-lint-langserver',
    'goimports',
    'gomodifytags',
    'golines',
    'gotests',
    'gotestsum',
    'iferr',
    'impl',
  })
end
if opt_languages.ocaml then
  packages[#packages + 1] = 'ocaml-lsp'
end
if opt_languages.rust then
  vim.list_extend(packages, { 'rust-analyzer', 'rustfmt' })
end
if opt_languages.typescript then
  vim.list_extend(packages, {
    'typescript-language-server',
    'tailwindcss-language-server',
    'prettier',
    'graphql-language-service-cli',
    'eslint-lsp',
  })
end
if opt_languages.terraform then
  packages[#packages + 1] = 'terraform-ls'
end
if opt_languages.zig then
  packages[#packages + 1] = 'zls'
end

require('mason').setup()
require('mason-tool-installer').setup({
  ensure_installed = packages,
})
