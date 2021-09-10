local packer = require("packer")
local plug = {
	specs = {},
	packer = {
		ready = false,
	},
}

function plug.use(spec)
	plug.specs[#plug.specs + 1] = spec
end

-- lazy loading Packer
function plug.ensure_packer()
	if plug.packer.ready then
		return
	end

	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd("packadd packer.nvim")
	end
	packer.init({
		display = {
			open_fn = require("packer.util").float,
		},
	})
	plug.packer.ready = true
end

function plug.sync()
	plug.ensure_packer()
	packer.sync()
end

function plug.compile()
	plug.ensure_packer()
	packer.compile()
end

function plug.unset()
	plug.specs = {}
	packer.reset()
end

return plug
