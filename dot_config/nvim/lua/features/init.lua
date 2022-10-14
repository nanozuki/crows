---@type Feature[]
local features = {
  require('features.basic'),
  require('features.color_hint'),
  require('features.snippets'),
  require('features.completion'),
  require('features.editor'),
  require('features.file_browser'),
  require('features.search'),
  -- statusline and tabline require themes
  require('features.theme'),
  require('features.statusline'),
  require('features.tabline'),
  require('features.startify'),
  require('features.lsp'),
}

for _, lang in ipairs(require('features.languages')) do
  table.insert(features, lang)
end
-- format requires languages
table.insert(features, require('features.format'))

return features
