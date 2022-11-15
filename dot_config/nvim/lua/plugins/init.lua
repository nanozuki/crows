local plugins = {}

plugins.which_key_nvim = function()
  require('which-key').setup({})
end

plugins.neogit = function()
  require('neogit').setup({ integrations = { diffview = true } })
end

plugins.fidget_nvim = function()
  require('fidget').setup({})
end

plugins.go_nvim = function()
  require('go').setup()
end

return plugins
