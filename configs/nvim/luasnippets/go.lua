local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require('luasnip.extras').lambda
-- local rep = require('luasnip.extras').rep
-- local p = require('luasnip.extras').partial
-- local m = require('luasnip.extras').match
-- local n = require('luasnip.extras').nonempty
-- local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local types = require('luasnip.util.types')
-- local conds = require('luasnip.extras.expand_conditions')

-- utils
local function goErrorHandle(index)
  return c(index, {
    sn(nil, fmt([[return {}err{}]], { i(1), i(2) })),
    sn(nil, fmt([['log.Error().Msg({})']], { i(1, 'err.Errors()') })),
  })
end
local function goReceiver(args)
  local type = args[1][1]
  if type == '' then
    return ''
  end
  local rec = string.match(type, '.*(%u)')
  if rec then
    return string.lower(rec)
  end
  return string.match(type, '%l')
end
local function copy(args)
  return args[1][1]
end

-- golang snippet

-- stylua: ignore start
return {
  s('ife', fmt([[
    if {} := {}; err != nil {{
        {}
    }}]],
    { i(1, 'err'), i(2), goErrorHandle(3), }
  )),

  s('efi', fmt([[
    if err != nil {{
        {}
    }}]],
    { goErrorHandle(1) }
  )),

  s('cc', t("ctx context.Context")), -- context parameter

  s('func', fmt([[
    func {}({}) {} {{
        {}
    }}]],
    { i(1), i(2), i(3), i(4) }
  )),

  s('method', fmt([[
    func ({} {}) {}({}) {} {{
        {}
    }}]],
    { f(goReceiver, {1}), i(1), i(2), i(3), i(4), i(5) }
  )),

  s('endpoint', fmt([[
    type {}Request struct {{
        {}
    }}

    type {}Response struct {{
        {}
    }}

    func ({} {}) {}(ctx context.Context, req *{}Request) (*{}Response, error) {{
        {}
    }}]], {
      f(copy, {2}), i(3),
      f(copy, {2}), i(4),
      f(goReceiver, {1}), i(1), i(2), f(copy, {2}), f(copy, {2}),
      i(5),
    }
  ))
}
-- stylua: ignore end
