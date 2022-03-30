local keymap = require('crows.keymap')
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
    bootstrap = plugin.bootstrap,
  },
}

local reload_modules = {}

---@class CrowsOption
---@field reload_modules string[]

---setup crows
---@param opt CrowsOption
function crows.setup(opt)
  reload_modules = opt.reload_modules
  vim.cmd([[command! CrowsReload lua require('crows').reload()]])
  vim.cmd([[command! CrowsResync lua require('crows').resync()]])
  vim.cmd([[command! CrowsUpdate lua require('crows').external_resync()]])
end

function crows.packadd(pack)
  local ok, err = pcall(vim.cmd, 'packadd ' .. pack)
  if not ok then
    print('packadd failed: ', err)
  end
  return ok
end

local function reset()
  for _, m in ipairs(reload_modules) do
    require('plenary.reload').reload_module(m)
  end
  plugin.reset()
  keymap.reset()
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
  vim.notify('quit all!')
  vim.cmd('qa!')
end

function crows.external_resync()
  plugin.sync_and_quit()
end

return crows
