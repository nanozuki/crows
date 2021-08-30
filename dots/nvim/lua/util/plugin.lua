local plugin = {}
plugin.plugins = {
	-- paq-nvim itself
	"savq/paq-nvim",
	-- basic lua library extension
	"nvim-lua/plenary.nvim",

	-- languages extra functions
	"mattn/emmet-vim", -- ft = {'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact'}})
	"dag/vim-fish", -- ft = {'fish'}})
}

local function auto_install_paq()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", install_path })
	end
end

function plugin.use(plug)
	table.insert(plugin.plugins, plug)
end

function plugin.setup()
	auto_install_paq()
	require("paq")(plugin.plugins)
end

function plugin.list()
	for _, value in ipairs(plugin.plugins) do
		print(value)
	end
end

return plugin
