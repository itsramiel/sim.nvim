local Async = require("snacks.picker.util.async")

local M = {}

---@generic T
---@param fn fun(cb: fun(T): nil): T
M.proc = function(fn)
  local self = Async.running()

  self:suspend()
end

return M
