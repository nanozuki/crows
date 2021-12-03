local crows = {
  plugins = {},
  setups = {},
  status = {
    run = false,
  },
}

local function reset()
  vim.cmd('packadd packer.nvim')
  require('packer').reset()
  require('which-key').reset()
  crows.plugins = {}
  crows.setups = {}
end

local function do_setup()
  for _, setup in ipairs(crows.setups) do
    setup()
  end
end

local function use_plugins()
  for _, plugin in ipairs(crows.plugins) do
    require('packer').use(plugin)
  end
end

--only run once
function crows.run()
  if crows.status.run then
    return
  end
  do_setup()
  crows.status.run = true
end

function crows.reload_resync_complied()
  local file = require('packer').config.compile_path
  local ok, err = pcall(vim.cmd, 'source ' .. file)
  if not ok then
    vim.notify("source packer's compiled file fail: " .. tostring(err), 'warn')
  end
  do_setup()
end

function crows.reload()
  reset()
  crows.execute('init.lua')
  use_plugins()
  vim.cmd("autocmd User PackerCompileDone lua require'crows'.reload_resync_complied()")
  vim.cmd('doautocmd User PackerCompileDone')
  require('packer').compile()
end

function crows.resync()
  reset()
  crows.execute('init.lua')
  use_plugins()
  vim.cmd("autocmd User PackerCompileDone lua require'crows'.reload_resync_complied()")
  vim.cmd('doautocmd User PackerCompileDone')
  require('packer').sync()
end

function crows.external_resync_compiled()
  vim.cmd('qa!')
end

function crows.external_resync()
  crows.reset()
  crows.execute('init.lua')
  use_plugins()
  vim.cmd("autocmd User PackerCompileDone lua require'crows'.external_resync_complied()")
  vim.cmd('doautocmd User PackerCompileDone')
  require('packer').sync()
end

function crows.must_install(name, path, type)
  local install_path = table.concat({ vim.fn.stdpath('data'), 'site/pack/packer', type, name }, '/')
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth=1', path, install_path })
    if type == 'start' then
      local cmd = 'packadd ' .. name
      vim.cmd(cmd)
    end
  end
end

function crows.use_plugin(spec)
  crows.plugins[#crows.plugins + 1] = spec
end

function crows.setup(setup_fn)
  crows.setups[#crows.setups + 1] = setup_fn
end

function crows.execute(filename)
  if filename ~= 'init.lua' then
    filename = 'lua/' .. filename
  end
  vim.cmd('runtime! ' .. filename)
end

return crows
