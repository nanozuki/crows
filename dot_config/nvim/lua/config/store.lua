-- lua variables and functions for plugins and scripts

---@class LspKeyMapper
---@field [1] string key
---@field [2] string|function command
---@field [3] string description

---@alias LspKeyMappers table<string, LspKeyMapper>
---@alias LspOnAttachCallback fun(client:table,bufnr:number)
---@alias LspCapabilitiesMaker fun(caps:table):table

local store = {
  ---@type table<string, string>
  color_palette = {},
  diagnostic_signs = { Error = '󰅚', Warn = '󰀪', Info = '', Hint = '󰌶' },
}

return store
