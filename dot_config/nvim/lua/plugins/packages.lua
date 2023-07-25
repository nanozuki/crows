local lsp = require('config.lsp')
local values = require('config.values')

local function packages()
  local pkgs = {}
  for _, server in pairs(lsp.servers) do
    if type(server.meta.pkg) == 'string' then
      pkgs[#pkgs + 1] = server.meta.pkg
    elseif type(server.meta.pkg) == 'table' then
      vim.list_extend(pkgs, server.meta.pkg--[=[@as string[]]=])
    end
  end
  for _, pkg in pairs(values.packages) do
    pkgs[#pkgs + 1] = pkg
  end
  return pkgs
end

return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    lazy = true,
    config = function()
      require('mason').setup({
        max_concurrent_installers = 16,
      })
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = packages(),
        auto_update = true,
      })
      vim.cmd('MasonToolsInstall')
    end,
  },
}
