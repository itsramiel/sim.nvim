local models = require("sim.api.models")

local shutdown_ios_virtual_device = require("sim.api.shutdown.shutdown_ios_virtual_device")
local shutdown_android_virtual_device = require("sim.api.shutdown.shutdown_android_virtual_device")

---@async
---@param device any
---@return boolean
local function shutdown_device(device)
  if models.IOSVirtualDevice.is_ios_virtual_device(device) then
    ---@cast device IOSVirtualDevice
    return shutdown_ios_virtual_device(device.name)
  elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
    ---@cast device AndroidVirtualDevice
    if device.adb_name ~= nil then
      return shutdown_android_virtual_device(device.adb_name)
    else
      return false
    end
  end

  return false
end

return shutdown_device
