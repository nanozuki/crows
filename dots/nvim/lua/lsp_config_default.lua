local nvim_lsp = require 'lspconfig'
local configs = require 'lspconfig/configs'

if not nvim_lsp.golangcilsp then
  configs.golangcilsp = {
    default_config = {
      cmd = {'golangci-lint-langserver'},
      root_dir = nvim_lsp.util.root_pattern('.git', 'go.mod'),
      filetypes = {'go'},
      init_options = {
        command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json" };
      },
    };
  }
end
