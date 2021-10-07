local feature = require('fur.feature')

local rust = feature:new('lang.rust')
rust.source = 'lua/lang/rust.lua'
rust.plugins = {
  {
    'simrat39/rust-tools.nvim',
    ft = { 'rust' },
    config = function()
      local opts = {
        tools = {
          -- inlay_hints = {
          -- 	show_parameter_hints = false,
          -- },
        },
      }
      require('rust-tools').setup(opts)
    end,
  },
}
rust.setup = function()
  require('lib.lsp').set_config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { disabled = { 'unresolved-proc-macro' } },
        checkOnSave = { command = 'clippy' },
      },
    },
  })
end

return rust
