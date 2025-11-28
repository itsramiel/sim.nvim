---@class AndroidVirtualDevice
---@field name string
---@field adb_name string?

local M = {}

local mt = {}

---@param name string
---@param adb_name string?
---@return AndroidVirtualDevice
M.new = function(name, adb_name)
  ---@type AndroidVirtualDevice
  local device = {
    name = name,
    adb_name = adb_name,
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
