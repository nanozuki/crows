local noremap = require("util/shim").noremap
local augroup = require("util/shim").augroup
local autocmd = require("util/shim").autocmd

vim.cmd("syntax enable")
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
-- copy selection to system clipboard
noremap("v", "<Leader>y", '"+y')
-- paste from system clipboard
noremap("n", "<Leader>p", '"+p')
-- ignore file for all
vim.cmd("set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store")
-- save as sudo
noremap("c", "w!!", "w !sudo tee %")

augroup("filetypes", {
	autocmd("BufNewFile,BufRead", "*html", "setfiletype html"),
	autocmd("BufNewFile,BufRead", "tsconfig.json", "setfiletype jsonc"),
	autocmd("BufNewFile,BufRead", "*.zig", "setfiletype zig"),
})

--- [plugin] ultisnips {{{
vim.g["UltiSnipsExpandTrigger"] = "<c-e>"
vim.g["UltiSnipsJumpForwardTrigger"] = "<c-e>"
vim.g["UltiSnipsJumpBackwardTrigger"] = "<c-h>"
--- }}}

--- [plugin] nerdtree {{{
noremap("", "<Leader>fl", ":NERDTreeToggle<CR>")
vim.g["NERDTreeWinSize"] = 32
vim.g["NERDTreeWinPos"] = "left"
vim.g["NERDTreeShowHidden"] = 1
vim.g["NERDTreeMinimalUI"] = 1
vim.g["NERDTreeAutoDeleteBuffer"] = 1
vim.g["NERDTreeRespectWildIgnore"] = 1
--- }}}

--- [plugin] ale {{{
vim.g.ale_disable_lsp = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_sign_error = "✗"
vim.g.ale_sign_warning = "‼"
local ale_config = {
	javascript = { "eslint" },
	javascriptreact = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	go = { "goimports" },
	lua = { "stylua" },
}
vim.g.ale_linters = ale_config
vim.g.ale_fixers = ale_config
--- }}}
