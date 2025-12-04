local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local d = ls.dynamic_node

-- stylua: ignore start
return {
  s('mod', fmt([[
    local {} = {{}}

    {}

    return {}]],
    {
      i(1, "M"),
      i(0),
      f(function (args)
        return args[1][1]
      end, {1}),
    }
  )),

  s('lrq', fmt("local {} = require('{}')",
    {
      d(2, function (args)
        local words = vim.split(args[1][1], '%.', { trimempty = true })
        return sn(nil, {i(1, words[#words])})
      end, {1}),
      i(1),
    })
  ),
}
-- stylua: ignore end
