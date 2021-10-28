local feature = require('fur.feature')

local function nvim_cmp_setup()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  require('luasnip.loaders.from_vscode').load()
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
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), // overtaken by auto-pair
      ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(s_tab, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'buffer' },
    },
  })

  ---@diagnostic disable-next-line: undefined-field
  cmp.setup.cmdline(':', { sources = cmp.config.sources({ { name = 'path' }, { name = 'cmdline' } }) })
  ---@diagnostic disable-next-line: undefined-field
  cmp.setup.cmdline('/', { sources = cmp.config.sources({ { name = 'buffer' } }) })

  require('nvim-autopairs').setup({})
  require('nvim-autopairs.completion.cmp').setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
    auto_select = true, -- automatically select the first item
    insert = false, -- use insert confirm behavior instead of replace
  })
end

local complete = feature:new('complete')
complete.source = 'lua/features/complete.lua'
complete.plugins = {
  {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'windwp/nvim-autopairs',
      -- snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
    },
    config = nvim_cmp_setup,
  },
}

return complete
