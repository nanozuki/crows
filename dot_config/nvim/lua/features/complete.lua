local crows = require('crows')

crows.use_plugin({
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'windwp/nvim-autopairs',
    'hrsh7th/cmp-cmdline',
    -- snippets
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').load()
    local function tab(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
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
        ['<CR>'] = cmp.mapping({
          i = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          c = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }, fallback)
            else
              fallback()
            end
          end,
        }),
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

    -- cmp-cmdline
    cmp.setup.cmdline(':', { sources = { { name = 'cmdline' }, { name = 'path' } } })
    cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

    -- nvim-autopairs
    require('nvim-autopairs').setup({})
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
})
