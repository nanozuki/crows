local keymap = require('crows.keymap')
local lsp = require('crows.lsp')
local plugin = require('crows.plugin')

---@class CrowsModule
---@field key table
---@field plugin table

---@type CrowsModule
local crows = {
  key = {
    map = keymap.map,
    maps = keymap.maps,
  },
  plugin = {
    use = plugin.use,
  },
}

local modules = {}

---@class CrowsOption
---@field modules string[]

---setup crows
---@param opt CrowsOption
function crows.setup(opt)
  modules = opt.modules
  vim.cmd([[command! CrowsReload lua require('crows').reload()
            command! CrowsResync lua require('crows').resync()
            command! CrowsInit   lua require('crows').init()
            command! CrowsUpdate lua require('crows').external_resync()]])
  if plugin.is_ready() then
    require('which-key').setup({})
    for _, mod in ipairs(modules) do
      require(mod)
    end
    return
  end
  crows.init()
end

function crows.init()
  plugin.init("require'crows'.after_init()")
end

function crows.after_init()
  for _, mod in ipairs(modules) do
    require(mod)
  end
  crows.resync()
end

function crows.ensure_pack(pack)
  local ok, err = pcall(vim.cmd, 'packadd ' .. pack)
  if not ok then
    vim.notify('packadd failed: ' .. tostring(err), 'warn')
    return false
  end
  ok, err = pcall(require, pack)
  if not ok then
    vim.notify('require failed: ' .. tostring(err), 'warn')
    return false
  end
  return true
end

local function reset()
  for _, m in ipairs(modules) do
    require('plenary.reload').reload_module(m)
  end
  plugin.reset()
  keymap.reset()
  lsp.stop_all_clients()
  vim.cmd('runtime! init.lua')
end

function crows.reload()
  reset()
  plugin.compile()
end

function crows.resync()
  reset()
  plugin.sync()
end

function crows.external_resync_compiled()
  vim.cmd('qa!')
end

function crows.external_resync()
  plugin.sync_and_quit()
end

return crows
