local function config()
  local section = {}

  section.header = {
    type = 'text',
    val = {
      [[                               __                ]],
      [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
      [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
      [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
      [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
      [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    },
    opts = {
      position = 'center',
      hl = 'Type',
      -- wrap = "overflow";
    },
  }

  --- @param shortcut string
  --- @param text string
  --- @param on_press function
  local function button(shortcut, text, on_press)
    return {
      type = 'button',
      val = text,
      on_press = on_press,
      opts = {
        keymap = { 'n', shortcut, '', { noremap = true, silent = true, nowait = true, callback = on_press } },
        position = 'center',
        hl = 'Special',
        shortcut = shortcut,
        align_shortcut = 'right',
        hl_shortcut = 'Define',
        cursor = 2,
        width = 50,
      },
    }
  end

  section.buttons = {
    type = 'group',
    val = {
      button('<leader>e', ' New file', function()
        local bufnr = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_set_current_buf(bufnr)
      end),
      button('<leader>z', '󰎐 Zip to recent folder', function()
        require('telescope').extensions.z.list()
      end),
      button('<leader>s', '󰉓 Open Session', function()
        require('auto-session.session-lens').search_session()
      end),
      button('<leader>u', '󰚰 Plugin update', function()
        require('lazy').sync()
      end),
      button('<leader>p', '󰓅 Starup profile', function()
        require('lazy').profile()
      end),
    },
    opts = {
      spacing = 1,
    },
  }

  math.randomseed(os.time())

  local footers = {
    'Hyperextensible Vim-based text editor.            ',
    'Help poor children in Uganda!                     ',
    'Customized by @Nanozuki.Crows.                    ',
  }

  section.footer = {
    type = 'text',
    val = footers[math.random(#footers)],
    opts = {
      position = 'center',
      hl = 'Tag',
    },
  }

  require('alpha').setup({
    layout = {
      { type = 'padding', val = 4 },
      section.header,
      { type = 'padding', val = 4 },
      section.buttons,
      { type = 'padding', val = 2 },
      section.footer,
    },
    opts = {
      margin = 5,
    },
  })
end

return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
