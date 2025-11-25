local models = require("sim.api.models")

local shutdown_ios_virtual_device = require("sim.api.shutdown.shutdown_ios_virtual_device")

---@param device any
---@param callback (fun(success: boolean): nil)?
local function shutdown_device(device, callback)
	if models.IOSVirtualDevice.is_ios_virtual_device(device) then
		---@cast device IOSVirtualDevice
		shutdown_ios_virtual_device(device.name, callback)
	elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
		---@cast device AndroidVirtualDevice
	end
end

return shutdown_device
