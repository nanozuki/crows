local settings = require('config.settings')

local function make_theme()
  local alt_bg = vim.g.terminal_color_0
  if settings.theme.name == 'zenbones' then
    alt_bg = vim.g.terminal_color_8
  end
  local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
  return {
    line = 'TabLineFill',
    head = { fg = vim.g.terminal_color_5, style = 'bold' },
    current_tab = { fg = vim.g.terminal_color_6, bg = normal_bg, style = 'bold' },
    tab = 'TabLine',
    win = { fg = vim.g.terminal_color_7, bg = alt_bg },
    current_win = { fg = vim.g.terminal_color_2, bg = alt_bg, style = 'bold' },
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

local tab_numbers = { '󰎤', '󰎧', '󰎪', '󰎭', '󰎱', '󰎳', '󰎶', '󰎹', '󰎼', '󰽽' }

local function config()
  vim.opt.showtabline = 2
  require('tabby').setup({
    line = function(line)
      local cwd = ' 󰉋 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
      local git_head = vim.g.gitsigns_head
      if git_head and git_head ~= '' then
        cwd = cwd .. '󰘬 ' .. git_head .. ' '
      end
      return {
        { cwd, ' ', hl = theme.head },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab
          return {
            ' ',
            tab_numbers[tab.number()] or string.format('%d:', tab.number()),
            tab.name(),
            margin = ' ',
            ' ',
            hl = hl,
          }
        end),
        line.spacer(),
        {
          { '  ', hl = theme.current_win },
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              win.buf_name(),
              hl = win.is_current() and theme.current_win or theme.win,
            }
          end, { margin = ' ' }),
          ' ',
          hl = theme.win,
        },
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
