local M = {}

function M.on_attach()
  require'completion'.on_attach({
    confirm_key='',
    matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'},
    sorting = 'alphabet',
    enable_snippet = 'UltiSnips',
  })
end

local opt = require'shim'.opt
local noremap = require'shim'.noremap

noremap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
noremap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
opt('o', 'completeopt', 'menuone,noinsert,noselect')

return M
