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
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--- load plugins
require('lazy').setup('plugins')
