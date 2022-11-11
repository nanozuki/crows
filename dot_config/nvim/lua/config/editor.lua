-- # basic setting
vim.g.mapleader = ' '
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.modelines = 1
vim.opt.colorcolumn = '120'
vim.cmd('syntax enable')
vim.cmd('set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store')
vim.keymap.set('c', 'w!!', 'w !sudo tee %', { desc = 'Save as sudo' })

-- # copy paste
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.opt.ignorecase = true
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = 'Clear search' })

-- # abount filetypes
-- filetype
vim.cmd([[filetype on]])
vim.cmd([[filetype plugin on]])
local filetypes = {
  ['*html'] = 'html',
  ['tsconfig.json'] = 'jsonc',
}
local ft_group = vim.api.nvim_create_augroup('filetypes', {})
for pattern, filetype in pairs(filetypes) do
  vim.api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    { group = ft_group, pattern = pattern, command = 'setfiletype ' .. filetype, once = true }
  )
end

-- # indent
vim.cmd('filetype indent on')
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
local fi_group = vim.api.nvim_create_augroup('fileindent', {})
vim.api.nvim_create_autocmd('FileType', {
  group = fi_group,
  pattern = 'lua,javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json,terraform',
  command = 'setlocal expandtab ts=2 sw=2 sts=2',
})

-- # fold
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- # terminal
vim.keymap.set('n', '<leader>tw', ':terminal<CR>', { desc = 'Open terminal in current window' })
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>', { desc = 'Open terminal in new tab' })
vim.keymap.set('t', '<C-K>', [[<C-\><C-N>]], { desc = 'To normal mode in terminal', expr = true })