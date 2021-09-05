local termcode = require("util/shim").termcode

local check_back_space = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local function setup()
	local exists, cmp = pcall(require, "cmp")
	if not exists then
		return
	end
	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		sorting = {
			priority_weight = 1,
		},
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		documentation = {},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(termcode("<C-n>"), "n")
				elseif vim.fn["vsnip#available"]() == 1 then
					vim.fn.feedkeys(termcode("<Plug>(vsnip-expand-or-jump)"), "")
				elseif check_back_space() then
					vim.fn.feedkeys(termcode("<Tab>"), "n")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(termcode("<C-p>"), "n")
				elseif vim.fn["vsnip#available"]() == 1 then
					vim.fn.feedkeys(termcode("<Plug>(vsnip-jump-prev)"), "")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "vsnip" },
			{ name = "path" },
			{ name = "buffer" },
		},
	})
end

setup()
