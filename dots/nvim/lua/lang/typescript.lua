local crows = require('crows')
local util = require('lspconfig/util')

require('lib.lsp').set_config('tsserver', {
  root_dir = function(fname)
    return util.root_pattern('tsconfig.json')(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
  end,
})

require('lib.lsp').set_config('denols', {
  root_dir = util.root_pattern('deno_root'),
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
  },
})

crows.use_plugin({
  'mattn/emmet-vim',
  ft = { 'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact' },
})
