local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local function workspace_files()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
  if cwd == '~/.config/nvim' then
    -- Make the server aware of Neovim runtime files, only in config cwd
    return vim.api.nvim_get_runtime_file('', true)
  end
  return nil
end

local sumneko_lua_settings = {
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      completion = {
        autoRequire = false,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = workspace_files(),
        maxPreload = 5000,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
require('crows.lsp').set_config('sumneko_lua', sumneko_lua_settings)

-- Teal Luangage
require('crows').plugin.use('teal-language/vim-teal')
