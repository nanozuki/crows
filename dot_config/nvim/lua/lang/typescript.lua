local crows = require('crows')
local util = require('lspconfig/util')

require('crows.lsp').set_config('tsserver', {
  root_dir = function(fname)
    return util.root_pattern('tsconfig.json')(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
  end,
})

require('crows.lsp').set_config('tailwindcss', {
  root_dir = util.root_pattern('tailwind.config.js', 'tailwind.config.ts'),
})

require('crows.lsp').set_config('denols', {
  root_dir = util.root_pattern('deno_root'),
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
  },
})

require('crows.lsp').set_config('graphql', {
  filetypes = { 'graphql' },
})

crows.plugin.use({
  'mattn/emmet-vim',
  ft = { 'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact' },
})
