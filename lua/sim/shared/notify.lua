---@param message string
local function notify(message)
  vim.notify(message, vim.log.levels.INFO, { title = "sim.lua" })
end

return notify
