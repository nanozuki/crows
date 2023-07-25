local langs = require('config.langs')

local dont_install = "DON'T INSTALL"

local package_map = {
  cssls = 'css-lsp',
  denols = dont_install,
  dlv = 'delve',
  html = 'html-lsp',
  jsonls = 'json-lsp',
  lua_ls = 'lua-language-server',
  ocamllsp = 'ocaml-lsp',
  rust_analyzer = 'rust-analyzer',
  rustfmt = dont_install,
  tailwindcss = 'tailwindcss-language-server',
  terraformls = 'terraform-ls',
  tsserver = 'typescript-language-server',
  vimls = 'vim-language-server',
  yamlls = 'yaml-language-server',
}

local pkgs = {}

local function add_pkg(pkg)
  if string.match(pkg, '^lsp:') then
    return
  end
  local p = package_map[pkg]
  if p == nil then
    pkgs[#pkgs + 1] = pkg
  elseif p ~= dont_install then
    pkgs[#pkgs + 1] = p
  end
end

local function packages()
  for _, spec in pairs(langs) do
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
  return pkgs
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
      vim.cmd('MasonToolsInstall')
    end,
  },
}
