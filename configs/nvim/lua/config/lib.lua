local lib = {}

function lib.feedkeys(str)
  local key = vim.api.nvim_replace_termcodes(str, true, false, true)
  vim.api.nvim_feedkeys(key, 't', false)
end

return lib
