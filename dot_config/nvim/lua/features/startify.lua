---@type Feature
local startify = { plugins = {} }

local if_nil = vim.F.if_nil

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

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
  local leader = 'SPC'
  local sc_ = sc:gsub('%s', ''):gsub(leader, '<leader>')
  local opts = {
    position = 'center',
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = 'right',
    hl_shortcut = 'Keyword',
  }
  if keybind then
    keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { 'n', sc_, keybind, keybind_opts }
  end

  local function on_press()
    -- local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
    local key = vim.api.nvim_replace_termcodes(sc_ .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

section.buttons = {
  type = 'group',
  val = {
    button('e', '  New file', '<cmd>ene <CR>'),
    button('SPC z', '  Zip to recent folder'),
    button('SPC f s', '  Open Session'),
    button('SPC f f', '  Find file'),
    button('SPC f g', '  Find word'),
    button('SPC f m', '  Jump to bookmarks'),
    button('SPC f h', 'ﬤ  Find help documents'),
  },
  opts = {
    spacing = 1,
  },
}

math.randomseed(os.time())
local footers = {
  'Hyperextensible Vim-based text editor.             ',
  'Help poor children in Uganda!                      ',
  'Customized by @Nanozuki.Crows.                     ',
}

section.footer = {
  type = 'text',
  val = footers[math.random(#footers)],
  opts = {
    position = 'center',
    hl = 'Tag',
    width = 50,
  },
}

startify.config = {
  layout = {
    { type = 'padding', val = 16 },
    section.header,
    { type = 'padding', val = 4 },
    section.buttons,
    { type = 'padding', val = 2 },
    section.footer,
  },
  opts = {
    margin = 5,
  },
}

startify.plugins[1] = {
  'goolord/alpha-nvim',
  requires = { 'kyazdani42/nvim-web-devicons' },
  config = function()
    require('alpha').setup(require('features.startify').config)
  end,
}

return startify
