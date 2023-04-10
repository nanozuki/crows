-- custom theme
local modes = { 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }
local function make_theme()
  local custom = require('config.custom')
  if custom.theme ~= 'rose_pine_dawn' then
    return nil
  end
  local palette = require('rose-pine.palette')
  local theme = require('lualine.themes.rose-pine')
  for _, mode in ipairs(modes) do
    theme[mode].b.bg = palette.overlay
    theme[mode].c.bg = palette.surface
  end
  theme.visual.a.bg = palette.gold
  theme.inactive.a.bg = palette.iris
  return theme
end

-- custom components

local function file_info()
  local encoding = vim.opt.fileencoding:get()
  local format = vim.bo.fileformat
  return string.format('%s,%s', encoding, format)
end

local function lsp()
  local clients = vim.lsp.get_active_clients()
  local text = {}
  if clients and #clients > 0 then
    text[#text + 1] = 'LSP'
    for _, client in ipairs(clients) do
      if client.name == 'copilot' then
        text[#text + 1] = 'AI'
      end
    end
  end
  return table.concat(text, '+')
end

local function position()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(0))
  local text
  if row == 1 then
    text = string.format('TOP/%d:%d', lines, col)
  elseif row == lines then
    text = string.format('BOT/%d:%d', lines, col)
  else
    text = string.format('%3d/%d:%-3d', row, lines, col)
  end
  return text
end

local block = {
  '',
  draw_empty = true,
  separator = { left = '█' },
}

-- custom extensions
local nvim_tree = {
  filetypes = { 'NvimTree' },
  sections = {
    lualine_a = { block },
    lualine_c = { 'filetype' },
    lualine_z = { block },
  },
}

-- config
require('lualine').setup({
  options = {
    theme = make_theme(),
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', draw_empty = true },
      'diff',
      'diagnostics',
    },
    lualine_c = { { 'filename', path = 4 } },
    lualine_x = { 'filetype', { file_info, icon = '' } },
    lualine_y = { { lsp, icon = '' } },
    lualine_z = { { position, icon = '' } },
  },
  inactive_sections = {
    lualine_a = { block },
    lualine_b = {},
    lualine_c = { { 'filename', path = 4 } },
    lualine_x = { { file_info, icon = '' } },
    lualine_y = {},
    lualine_z = { block },
  },
  extensions = { nvim_tree },
})
