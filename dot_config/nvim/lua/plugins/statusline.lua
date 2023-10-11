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
  theme.inactive.a.fg = palette.base
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
  local names = vim.tbl_map(function(client)
    return client.name
  end, clients)
  return table.concat(names, ',')
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
  filetypes = { 'neo-tree' },
  sections = {
    lualine_a = { block },
    lualine_c = { 'filetype' },
    lualine_z = { block },
  },
}

local noice_recording = {
  function()
    ---@diagnostic disable-next-line: undefined-field
    return require('noice').api.status.mode.get()
  end,
  cond = function()
    ---@diagnostic disable-next-line: undefined-field
    return package.loaded['noice'] and require('noice').api.status.mode.has()
  end,
}

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      if values.use_global_statusline then
        vim.opt.laststatus = 3
      end
    end,
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
          lualine_b = { { 'branch', draw_empty = true }, 'diff', 'diagnostics' },
          lualine_c = {
            { 'filename', path = 1, symbols = { modified = '*', readonly = '' } },
            noice_recording,
          },
          lualine_x = { 'filetype', { file_info, icon = '󰋽' } },
          lualine_y = { { lsp, icon = '' } },
          lualine_z = { { position, icon = '󰆤' } },
        },
        inactive_sections = {
          lualine_a = { block },
          lualine_b = {},
          lualine_c = { { 'filename', path = 1, symbols = { modified = '*', readonly = '' } } },
          lualine_x = { { file_info, icon = '󰋽' } },
          lualine_y = {},
          lualine_z = { block },
        },
        extensions = { nvim_tree },
      })
    end,
  },
  {
    'b0o/incline.nvim',
    enabled = values.use_global_statusline,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local palette = values.theme.palette
      require('incline').setup({
        render = function(props)
          local filepath = vim.api.nvim_buf_get_name(props.buf)
          local name = vim.fn.fnamemodify(filepath, ':t')
          local ext = vim.fn.fnamemodify(filepath, ':e')
          local relative = vim.fn.fnamemodify(filepath, ':~::h')
          local icon = require('nvim-web-devicons').get_icon(name, ext, { default = true })
          return string.format('%s / %s %s', relative, icon, name)
        end,
        window = {
          margin = {
            vertical = 0,
            horizontal = 0,
          },
          winhighlight = {
            active = { Normal = { guifg = palette.base, guibg = palette.pine } },
            inactive = { Normal = { guifg = palette.base, guibg = palette.foam } },
          },
        },
      })
    end,
  },
}
