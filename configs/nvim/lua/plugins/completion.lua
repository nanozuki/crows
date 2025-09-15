local globals = require('config.globals')

return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    init = function()
      globals.lsp.cap_makers[#globals.lsp.cap_makers + 1] = function(caps)
        local blink_caps = require('blink.cmp').get_lsp_capabilities({}, false)
        caps = vim.tbl_deep_extend('force', caps, blink_caps)
        caps = vim.tbl_deep_extend('force', caps, {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        })
        return caps
      end
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },
      appearance = { nerd_font_variant = 'normal' },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true, window = { show_documentation = false } },
    },
    opts_extend = { 'sources.default' },
  },
}
