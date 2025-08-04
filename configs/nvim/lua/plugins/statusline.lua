local settings = require('config.globals').settings()

-- custom theme
local function make_theme()
  ---@type table<string, string>
  local modes = {
    normal = vim.g.terminal_color_6, -- cyan
    insert = vim.g.terminal_color_4, -- blue
    visual = vim.g.terminal_color_3, -- yellow
    replace = vim.g.terminal_color_2, -- green
    command = vim.g.termianl_color_1, -- red
    inactive = vim.g.terminal_color_5, -- magenta
  }
  local theme = {}
  local statusline_hl = vim.api.nvim_get_hl(0, { name = 'TabLineFill', link = false })
  local statusline_bg = string.format('#%06x', statusline_hl.bg)
  local b_bg = vim.g.terminal_color_0
  if settings.theme.name == 'zenbones' then
    b_bg = vim.g.terminal_color_8
  end
  for mode, accent in pairs(modes) do
    theme[mode] = {
      a = { fg = vim.g.terminal_color_0, bg = accent },
      b = { fg = accent, bg = b_bg },
      c = { fg = vim.g.terminal_color_7, bg = statusline_bg },
    }
  end
  return theme
end

-- custom components

local function file_info()
  local encoding = vim.opt.fileencoding:get()
  local format = vim.bo.fileformat
  return string.format('%s,%s', encoding, format)
end

local function lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = vim.tbl_map(function(client)
    if client.name == 'GitHub Copilot' then
      return 'copilot'
    end
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

local noice_recording = function()
  if not settings.hide_command_line then
    return ''
  end
  local reg = vim.fn.reg_recording()
  if reg == '' then
    return ''
  end
  return string.format('recording @%s', reg)
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      if settings.use_global_statusline then
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
    enabled = settings.use_global_statusline,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('incline').setup({
        render = function(props)
          local filepath = vim.api.nvim_buf_get_name(props.buf)
          local name = vim.fn.fnamemodify(filepath, ':t')
          local ext = vim.fn.fnamemodify(filepath, ':e')
          local relative = vim.fn.fnamemodify(filepath, ':~:.:h')
          local icon = require('nvim-web-devicons').get_icon(name, ext, { default = true })
          return string.format('%s / %s %s', relative, icon, name)
        end,
        hide = {
          focused_win = true,
        },
        window = {
          margin = {
            vertical = 0,
            horizontal = 0,
          },
          winhighlight = {
            active = { Normal = { guifg = vim.g.terminal_color_0, guibg = vim.g.terminal_color_2 } },
            inactive = { Normal = { guifg = vim.g.terminal_color_0, guibg = vim.g.terminal_color_4 } },
          },
        },
      })
    end,
  },
}
