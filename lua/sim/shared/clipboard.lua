local M = {}

---copies str to clipboard
---@param str string
function M.copy_to_clipboard(str)
  vim.fn.setreg("+", str)
end

return M
