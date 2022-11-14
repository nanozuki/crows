local palette = require('config.theme').palette
local theme = {
  line = { fg = palette.fg, bg = palette.bg },
  head = { fg = palette.bg, bg = palette.accent, style = 'italic' },
  current_tab = { fg = palette.bg, bg = palette.accent_sec, style = 'bold' },
  tab = { fg = palette.fg, bg = palette.bg_sec, style = 'bold' },
  win = { fg = palette.fg, bg = palette.bg_sec },
  tail = { fg = palette.bg, bg = palette.accent_sec, style = 'bold' },
}
vim.opt.showtabline = 2
require('tabby.tabline').set(function(line)
  local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
  return {
    { { cwd, hl = theme.head }, line.sep('', theme.head, theme.line) },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('', hl, theme.line),
        tab.is_current() and '' or '',
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
end, {})
