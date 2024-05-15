vim.loader.enable()

--- load custom settings
local settings_file = vim.fn.stdpath('config') .. '/settings.json'
local file = io.open(settings_file, 'r')
if file then
  local content = file:read('*a')
  local cfg = vim.fn.json_decode(content)
  local globals = require('config.globals')
  globals.settings = vim.tbl_deep_extend('force', globals.settings, cfg)
end

--- apply configs
require('config.configs')

--- plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--- load plugins
require('lazy').setup({ { import = 'plugins' } }, {
  concurrency = 16,
  change_detection = {
    notify = false,
  },
})
