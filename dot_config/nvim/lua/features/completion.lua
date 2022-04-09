---@type Feature
local completion = { plugins = {} }

completion.plugins[1] = {
  'gelguy/wilder.nvim',
  config = function()
    local wilder = require('wilder')
    wilder.setup({
      modes = { ':', '/', '?' },
    })
    wilder.set_option('pipeline', {
      wilder.branch(
        wilder.cmdline_pipeline({
          language = 'python',
          fuzzy = 1,
        }),
        wilder.python_search_pipeline({
          pattern = wilder.python_fuzzy_pattern(),
          sorter = wilder.python_difflib_sorter(),
          engine = 're',
        })
      ),
    })
    wilder.set_option(
      'renderer',
      wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
      })
    )
  end,
}

completion.plugins[2] = {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    -- snippets
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require('cmp')
    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    local function tab(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()
      end
    end
    local function s_tab(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()
      end
    end

    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      snippet = {
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping({
          c = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        }),
        ['<CR>'] = cmp.mapping({
          i = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          c = function(fallback)
            fallback()
          end,
        }),
        ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(s_tab, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'buffer' },
      },
    })
  end,
}

return completion
