local tabby_config = function()
  local palette = require('features.theme').palette
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
end

---@type Feature
local tabline = {}

tabline.plugins = {
  {
    'nanozuki/tabby.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = tabby_config,
  },
}

tabline.post = function()
  require('crows').key.maps({
    ['<leader>t'] = {
      c = { ':$tabnew<CR>', 'Create new tab' },
      x = { ':tabclose<CR>', 'Close current tab' },
      o = { ':tabonly<CR>', 'Close other tabs' },
      n = { ':tabn<CR>', 'Go to next tab' },
      p = { ':tabp<CR>', 'Go to previous tab' },
      m = {
        p = { ':-tabmove<CR>', 'Move current tab to previous position' },
        n = { ':+tabmove<CR>', 'Move current tab to next position ' },
      },
    },
    ['<leader>w'] = {
      o = {
        function()
          local tabid = vim.api.nvim_get_current_tabpage()
          local wins = vim.api.nvim_tabpage_list_wins(tabid)
          local current = vim.api.nvim_get_current_win()
          for _, win in ipairs(wins) do
            if win ~= current then
              vim.api.nvim_win_close(win, false)
            end
          end
        end,
        'Close other windows in this tab',
      },
      O = {
        function()
          local tabid = vim.api.nvim_get_current_tabpage()
          local wins = vim.api.nvim_tabpage_list_wins(tabid)
          for _, win in ipairs(wins) do
            if vim.api.nvim_win_get_config(win).relative ~= '' then
              vim.api.nvim_win_close(win, false)
            end
          end
        end,
        'Close floating windows in this tab',
      },
    },
  })
end

return tabline
