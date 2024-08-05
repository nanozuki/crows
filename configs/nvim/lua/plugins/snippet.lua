return {
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  run = 'make install_jsregexp',
  config = function()
    local ls = require('luasnip')
    ls.setup({
      updateevents = { 'TextChanged', 'TextChangedI' },
    })
    require('luasnip.loaders.from_lua').lazy_load()

    -- # keymapings
    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { desc = 'expand snippet or jump to next node', silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { desc = 'jump to preview node', silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = 'change choice', silent = true })
  end,
}
