---@class PluginModule
---@field bootstrapped boolean is bootstraped
---@field loaded boolean is packer.nvim loaded
---@field plugins PluginSpec[] used plugins

---@alias PluginSpec string|table

---@type PluginModule
local plugin = {
  bootstrapped = false,
  loaded = false,
  plugins = {},
}

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
local repository = 'https://github.com/wbthomason/packer.nvim'

function plugin.is_ready()
  return vim.fn.empty(vim.fn.glob(install_path)) == 0
end

function plugin.init(hook)
  if not plugin.is_ready() then
    vim.fn.system({ 'git', 'clone', '--depth', '1', repository, install_path })
  end
  plugin.load()
  plugin.sync(hook)
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
  plugin.load()
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

---set compiled hook function
---@param hook string
function plugin.set_compiled_hook(hook)
  vim.cmd(string.format(
    [[augroup compiled_hook
      autocmd!
      autocmd User PackerCompileDone lua %s
    augroup end]],
    hook
  ))
end

function plugin.sync(hook)
  use_plugins()
  hook = hook or "require'crows.plugin'.source_compiled()"
  plugin.set_compiled_hook(hook)
  require('packer').sync()
end

function plugin.compile(hook)
  use_plugins()
  hook = hook or "require'crows.plugin'.source_compiled()"
  plugin.set_compiled_hook(hook)
  require('packer').compile()
end

function plugin.sync_and_quit()
  use_plugins()
  vim.cmd('autocmd User PackerCompileDone <cmd>qall')
  require('packer').compile()
end

return plugin
