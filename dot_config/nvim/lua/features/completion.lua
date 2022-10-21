---@type Feature
local completion = { plugins = {} }

completion.plugins[#completion.plugins + 1] = {
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

--[[
completion.plugins[#completion.plugins + 1] = {
  'hrsh7th/cmp-cmdline',
  config = function()
    require('cmp').setup.cmdline(':', {
      sources = {
        { name = 'cmdline' },
      },
    })
    require('cmp').setup.cmdline('/', {
      sources = {
        { name = 'buffer' },
      },
    })
  end,
}
--]]

completion.plugins[#completion.plugins + 1] = {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    -- snippets
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local function tab(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end
    local function s_tab(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
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
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping({
          c = cmp.mapping.confirm({ select = true }),
        }),
        ['<CR>'] = cmp.mapping({
          i = cmp.mapping.confirm({ select = true }),
          c = function(fallback)
            fallback()
          end,
        }),
        ['<Tab>'] = cmp.mapping({ i = tab }),
        ['<S-Tab>'] = cmp.mapping({ i = s_tab }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'path' },
        { name = 'buffer' },
      }),
    })
  end,
}

completion.plugins[#completion.plugins + 1] = {
  'hrsh7th/cmp-nvim-lsp',
  config = function()
    require('crows.lsp').add_caps_setter(require('cmp_nvim_lsp').default_capabilities)
  end,
}

return completion
