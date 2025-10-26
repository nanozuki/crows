return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = { 'InsertEnter', 'CmdlineEnter' },
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
