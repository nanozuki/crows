---@class PluginModule
---@field bootstrapped boolean is bootstraped
---@field loaded boolean is packer.nvim loaded
---@field plugins PluginSpec[] used plugins
---@field base_plugins PluginSpec[] used plugins

---@alias PluginSpec string|table

---@type PluginModule
local plugin = {
  bootstrapped = false,
  loaded = false,
  plugins = {},
  base_plugins = {
    { 'wbthomason/packer.nvim', opt = true },
    {
      'folke/which-key.nvim',
      config = function()
        require('which-key').setup({})
      end,
    },
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
  },
}

function plugin.bootstrap()
  if plugin.bootstrapped then
    return
  end
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
  local packer = 'https://github.com/wbthomason/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth', '1', packer, install_path })
  end
  plugin.bootstrapped = true
end

function plugin.load()
  if plugin.loaded then
    return
  end
  vim.cmd('packadd packer.nvim')
  require('packer').init({
    display = {
      open_fn = require('packer.util').float,
    },
  })
  plugin.loaded = true
end

function plugin.reset()
  if plugin.loaded then
    require('packer').reset()
  end
  plugin.plugins = {}
end

function plugin.use(spec)
  plugin.plugins[#plugin.plugins + 1] = spec
end

local function use_plugins()
  plugin.bootstrap()
  plugin.load()
  for _, p in ipairs(plugin.base_plugins) do
    require('packer').use(p)
  end
  for _, p in ipairs(plugin.plugins) do
    require('packer').use(p)
  end
end

function plugin.source_compiled()
  local file = require('packer').config.compile_path
  local ok, err = pcall(vim.cmd, 'source ' .. file)
  if not ok then
    vim.notify("source packer's compiled file fail: " .. tostring(err), 'warn')
  end
end

function plugin.sync()
  use_plugins()
  vim.cmd("autocmd User PackerCompileDone lua require'crows.plugin'.source_compiled()")
  require('packer').sync()
end

function plugin.compile()
  use_plugins()
  vim.cmd("autocmd User PackerCompileDone lua require'crows.plugin'.source_compiled()")
  require('packer').compile()
end

function plugin.sync_and_quit()
  use_plugins()
  vim.cmd('autocmd User PackerCompileDone <cmd>qall')
  require('packer').compile()
end

return plugin
