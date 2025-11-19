---@class AndroidVirtualDevice
---@field name string
---@field booted boolean

local M = {}

local mt = {}

---@param name string
---@param booted boolean
---@return AndroidVirtualDevice
M.new = function(name, booted)
  ---@type AndroidVirtualDevice
  local device = {
    name = name,
    booted = booted,
  }

  setmetatable(device, mt)

  return device
end

---@param arg unknown
---@return boolean
M.is_android_virtual_device = function(arg)
  return getmetatable(arg) == mt
end

return M
