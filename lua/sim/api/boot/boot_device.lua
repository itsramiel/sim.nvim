local models = require("sim.api.models")
local boot_ios_virtual_device = require("sim.api.boot.boot_ios_virtual_device")
local boot_android_virtual_device = require("sim.api.boot.boot_android_virtual_device")

---@async
---@param device any
---@return boolean
local function boot_device(device)
	if models.IOSVirtualDevice.is_ios_virtual_device(device) then
		---@cast device IOSVirtualDevice
		return boot_ios_virtual_device(device.udid)
	elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
		---@cast device AndroidVirtualDevice
		return boot_android_virtual_device(device.name)
	end
	return false
end

return boot_device
