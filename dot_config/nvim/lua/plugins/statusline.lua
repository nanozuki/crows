local values = require('config.values')

-- custom theme

local modes = { 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }
local function make_theme()
  local theme_name = values.theme.name
  local palette = values.theme.palette
  if theme_name ~= 'rose_pine' then
    return nil
  end
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
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local status = {
    lang_servers = false,
    null_ls = false,
    copilot = false,
  }
  if clients and #clients > 0 then
    for _, client in ipairs(clients) do
      if client.name == 'copilot' then
        status.copilot = true
      elseif client.name == 'null-ls' then
        status.null_ls = true
      else
        status.lang_servers = true
      end
    end
  end
  local text = {}
  if status.lang_servers then
    if status.null_ls then
      text[#text + 1] = 'LSP+'
    else
      text[#text + 1] = 'LSP'
    end
  end
  if status.copilot then
    text[#text + 1] = 'AI'
  end
  return table.concat(text, ',')
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

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
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
        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = { modified = '*', readonly = '' },
          },
        },
        lualine_x = { 'filetype', { file_info, icon = '󰋽' } },
        lualine_y = { { lsp, icon = '' } },
        lualine_z = { { position, icon = '󰆤' } },
      },
      inactive_sections = {
        lualine_a = { block },
        lualine_b = {},
        lualine_c = { { 'filename', path = 4 } },
        lualine_x = { { file_info, icon = '󰋽' } },
        lualine_y = {},
        lualine_z = { block },
      },
      extensions = { nvim_tree },
    })
  end,
}
