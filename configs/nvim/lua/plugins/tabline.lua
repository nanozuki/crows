local settings = require('config.settings')

local function make_theme()
  local alt_bg = vim.g.terminal_color_0
  if settings.theme.name == 'zenbones' then
    alt_bg = vim.g.terminal_color_8
  end
  return {
    line = 'TabLineFill',
    head = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_5, style = 'italic' },
    current_tab = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_6, style = 'bold' },
    tab = { fg = vim.g.terminal_color_7, bg = alt_bg, style = 'bold' },
    win = { fg = vim.g.terminal_color_7, bg = alt_bg },
    tail = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_6, style = 'bold' },
  }
end

local theme = make_theme()

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    theme = make_theme()
  end,
})

local function config()
  vim.opt.showtabline = 2
  require('tabby').setup({
    line = function(line)
      local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
      return {
        { { cwd, hl = theme.head }, line.sep('', theme.head, theme.line) },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab
          return {
            line.sep('', hl, theme.line),
            tab.is_current() and '󰆤' or '󰆣',
            string.format('%s:', tab.number()),
            tab.name(),
            line.sep('', hl, theme.line),
            margin = ' ',
            hl = hl,
          }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          return {
            line.sep('', theme.win, theme.line),
            win.is_current() and '' or '',
            win.buf_name(),
            line.sep('', theme.win, theme.line),
            margin = ' ',
            hl = theme.win,
          }
        end),
        { line.sep('', theme.tail, theme.line), { '  ', hl = theme.tail } },
        hl = theme.line,
      }
    end,
  })
  vim.keymap.set('n', '<leader>wp', ':Tabby pick_window<CR>', { desc = 'Select a window' })
  vim.keymap.set('n', '<leader>tr', ':Tabby rename_tab ', { desc = 'Rename current tab' })
end

return {
  'nanozuki/tabby.nvim',
  event = 'VimEnter',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = config,
}
