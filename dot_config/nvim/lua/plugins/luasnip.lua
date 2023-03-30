local ls = require('luasnip')

-- # keymapings
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = 'expand snippet or jump to next node' })
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = 'jump to preview node' })
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

-- some shorthands...
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

-- Golang:
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

-- golang snippet
-- stylua: ignore start
ls.add_snippets('go', {
  s('ife', fmt([[
  if {} := {}; err != nil {{
      {}
  }}]], { i(1, 'err'), i(2), goErrorHandle(3), })),

  s('efi', fmt([[
  if err != nil {{
      {}
  }}]], { goErrorHandle(1) })),

  s('cc', t("ctx context.Context")), -- context parameter

  s('func', fmt([[
  func {}({}) {} {{
      {}
  }}]], { i(1), i(2), i(3), i(4) })),

  s('method', fmt([[
  func ({} {}) {}({}) {} {{
      {}
  }}]], { f(goReceiver, {1}), i(1), i(2), i(3), i(4), i(5) })),
})
-- stylua: ignore end

-- tsx snippet
-- stylua: ignore start
local function componentProp(args)
  return (args[1][1] or '')..'Props'
end
ls.add_snippets('typescriptreact', {
  s('comp', fmt([[
interface {} {{
  className?: string;
}}

function {}({{ className }}: {}) {{
  return (
    <div className={{`${{className || ''}}`}}>
    {}
    </div>
  );
}}]], {
    f(componentProp, {1}),
    i(1, "Component"),
    f(componentProp, {1}),
    i(0),
  })),
  s('ep', t('export')),
  s('epd', t('export default')),
})
-- stylua: ignore end
--[[
interface NominationProps {
  name: string;
  alias: string[];
  className?: string;
}

export default function Nomination({
  name,
  alias,
  className,
}: NominationProps) {
  return (
    <div className={`${className}`}>
      <p>{name}</p>
      <div>
        {alias.map((a) => (
          <p key={a}>{a}</p>
        ))}
      </div>
    </div>
  );
}
]]
--
