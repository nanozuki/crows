local langs = require('config.langs')

local no_need = 'NO NEED'

local package_map = {
  cssls = 'css-lsp',
  denols = no_need,
  dlv = 'delve',
  html = 'html-lsp',
  jsonls = 'json-lsp',
  lua_ls = 'lua-language-server',
  ocamllsp = 'ocaml-lsp',
  rust_analyzer = 'rust-analyzer',
  rustfmt = no_need,
  tailwindcss = 'tailwindcss-language-server',
  terraformls = 'terraform-ls',
  tsserver = 'typescript-language-server',
  vimls = 'vim-language-server',
  yamlls = 'yaml-language-server',
}

local function packages()
  local pkgs = {} ---@type table<string, boolean>
  local add_pkg = function(name)
    if string.match(name, '^lsp:') then
      return
    end
    local p = package_map[name]
    if p == nil then
      pkgs[name] = true
    elseif p ~= no_need then
      pkgs[p] = true
    else
    end
  end
  for _, spec in pairs(langs) do
    if spec.enable then
      for _, linter in ipairs(spec.linters or {}) do
        add_pkg(linter)
      end
      for _, formatter in ipairs(spec.formatters or {}) do
        add_pkg(formatter)
      end
      for _, tool in ipairs(spec.tools or {}) do
        add_pkg(tool)
      end
      for ls, _ in pairs(spec.servers or {}) do
        add_pkg(ls)
      end
    end
  end
  return vim.tbl_keys(pkgs)
end

return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    lazy = true,
    config = function()
      require('mason').setup({
        max_concurrent_installers = 16,
      })
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = packages(),
        auto_update = true,
      })
      vim.cmd('MasonToolsUpdate')
    end,
  },
}
