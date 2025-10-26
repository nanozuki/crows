local settings = require('config.settings')

return {
  settings = {
    gopls = {
      gofumpt = settings.use_gofumpt,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
