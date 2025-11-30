return {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = { disabled = { 'unresolved-proc-macro' } },
      checkOnSave = { command = 'clippy' },
    },
  },
}
