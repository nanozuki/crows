local crows = {
  plugins = {
    {
      'wbthomason/packer.nvim',
      opt = true,
    },
    {
      'folke/which-key.nvim',
      config = function()
        require('which-key').setup({})
      end,
    },
  },
  store = {},
  status = {
    run = false,
  },
}

local function reset()
  vim.cmd('packadd packer.nvim')
  require('packer').reset()
  require('which-key').reset()
  crows.plugins = {
    {
      'wbthomason/packer.nvim',
      opt = true,
    },
    {
      'folke/which-key.nvim',
      config = function()
        require('which-key').setup({})
      end,
    },
  }
  crows.store = {}
end

local function use_plugins()
  vim.cmd('packadd packer.nvim')
  require('packer').init({
    display = {
      open_fn = require('packer.util').float,
    },
  })
  for _, plugin in ipairs(crows.plugins) do
    require('packer').use(plugin)
  end
end

--only run once
function crows.run()
  if crows.status.run then
    return
  end
  crows.status.run = true
end

function crows.reload_resync_complied()
  local file = require('packer').config.compile_path
  local ok, err = pcall(vim.cmd, 'source ' .. file)
  if not ok then
    vim.notify("source packer's compiled file fail: " .. tostring(err), 'warn')
  end
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

function crows.execute(filename)
  if filename ~= 'init.lua' then
    filename = 'lua/' .. filename
  end
  vim.cmd('runtime! ' .. filename)
end

function crows.map(msg, mode, lhs, rhs, opt)
  if mode ~= 'n' then
    opt = opt or {}
    opt.mode = mode
  end
  require('which-key').register({ [lhs] = { rhs, msg } }, opt)
end

function crows.maps(mappings, opts)
  require('which-key').register(mappings, opts)
end

function crows.packadd(pack)
  local ok, err = pcall(vim.cmd, 'packadd ' .. pack)
  if not ok then
    print('packadd failed: ', err)
  end
  return ok
end

function crows.setv(key, value)
  crows.store[key] = value
end

function crows.getv(key)
  return crows.store[key]
end

return crows
