-- local_config.lua used to load local configs.
-- This module will find and execute lua files in this order:
-- 1. ~/.config/nvim/local.lua
-- 2. <current folder or nearest parent folder>/.nvim.local.lua

local M = {}

local function notify_error(message)
  vim.notify(message, vim.log.levels.ERROR, { title = 'local_config.lua' })
end

local function run_file(path)
  local content = vim.secure.read(path)
  if type(content) ~= 'string' then
    return false
  end

  local chunk, load_err = load(content, '@' .. path, 't')
  if not chunk then
    notify_error(('Failed to load %s: %s'):format(path, load_err))
    return false
  end

  local ok, exec_err = pcall(chunk)
  if not ok then
    notify_error(('Failed to execute %s: %s'):format(path, exec_err))
    return false
  end

  return true
end

local function find_config_file()
  local config_dir = vim.fs.normalize(vim.fn.stdpath('config'))
  return vim.fs.find(function(name, path)
    return name == 'local.lua' and vim.fs.normalize(path) == config_dir
  end, { path = config_dir, type = 'file', limit = 1 })[1]
end

local function find_project_file()
  local cwd = vim.uv.cwd()
  if not cwd then
    return nil
  end

  return vim.fs.find('.nvim.local.lua', {
    path = cwd,
    upward = true,
    type = 'file',
    limit = 1,
  })[1]
end

function M.load()
  local config_file = find_config_file()
  if config_file then
    run_file(config_file)
  end

  local project_file = find_project_file()
  if project_file then
    run_file(project_file)
  end
end

return M
