return {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        diagnostics = { disabled = { 'unresolved-proc-macro' } },
        checkOnSave = { command = 'clippy' },
      },
    },
  },
}
