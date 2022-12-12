require('dressing').setup({
  input = { win_options = { winblend = 0 } },
  select = {
    get_config = function(opts)
      if opts.kind == 'codeaction' then
        return {
          backend = 'builtin',
          builtin = { relative = 'cursor', max_width = 40 },
        }
      end
    end,
  },
})
