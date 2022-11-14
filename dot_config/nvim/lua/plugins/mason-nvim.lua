local packages = {}
for _, pkgs in pairs(require('config.languages').packages) do
  for _, pkg in ipairs(pkgs) do
    packages[#packages + 1] = pkg
  end
end
require('mason').setup()
require('mason-tool-installer').setup({
  ensure_installed = packages,
})
