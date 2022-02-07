local crows = require('crows')

-- autopairs
crows.use_plugin('jiangmiao/auto-pairs')

-- cmdline completion
crows.use_plugin({
  'gelguy/wilder.nvim',
  config = function()
    vim.cmd([[
      call wilder#setup({'modes': [':', '/', '?']})
      call wilder#set_option('pipeline', [
        \   wilder#branch(
        \     wilder#cmdline_pipeline({
        \       'language': 'python',
        \       'fuzzy': 1,
        \     }),
        \     wilder#python_search_pipeline({
        \       'pattern': wilder#python_fuzzy_pattern(),
        \       'sorter': wilder#python_difflib_sorter(),
        \       'engine': 're',
        \     }),
        \   ),
        \ ])
      call wilder#set_option('renderer', wilder#popupmenu_renderer({
        \ 'highlighter': wilder#basic_highlighter(),
        \ }))
    ]])
  end,
})

crows.use_plugin({
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
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
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
      },
    })
  end,
})
