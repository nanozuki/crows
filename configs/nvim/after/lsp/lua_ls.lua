return {
  settings = {
    Lua = {
      format = { enable = false },
      hint = { enable = true },
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
