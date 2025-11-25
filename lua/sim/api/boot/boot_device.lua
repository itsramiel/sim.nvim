local models = require("sim.api.models")
local boot_ios_virtual_device = require("sim.api.boot.boot_ios_virtual_device")
local boot_android_virtual_device = require("sim.api.boot.boot_android_virtual_device")

---@param device any
---@param callback (fun(success: boolean): nil)?
local function boot_device(device, callback)
	if models.IOSVirtualDevice.is_ios_virtual_device(device) then
		---@cast device IOSVirtualDevice
		boot_ios_virtual_device(device.udid, callback)
	elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
		---@cast device AndroidVirtualDevice
		boot_android_virtual_device(device.name, callback)
	end
end

return boot_device
