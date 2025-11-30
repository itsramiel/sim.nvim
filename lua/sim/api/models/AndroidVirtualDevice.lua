local boot_android_virtual_device = require("sim.api.boot.boot_android_virtual_device")
local shutdown_android_virtual_device = require("sim.api.shutdown.shutdown_android_virtual_device")

local M = {}

---@class AndroidVirtualDevice
---@field name string
---@field adb_name string?
local AndroidVirtualDevice = {}

M.AndroidVirtualDevice = AndroidVirtualDevice

---@param name string
---@param adb_name string?
---@return AndroidVirtualDevice
function AndroidVirtualDevice:new(name, adb_name)
	---@type AndroidVirtualDevice
	local device = {
		name = name,
		adb_name = adb_name,
	}

	self.__index = self

	setmetatable(device, self)

	return device
end

---@return boolean
function AndroidVirtualDevice:isBooted()
	return self.adb_name ~= nil
end

function AndroidVirtualDevice:boot()
	local adb_id = boot_android_virtual_device(self.name)
	self.adb_name = adb_id

	return adb_id ~= nil
end

---@return boolean
function AndroidVirtualDevice:shutdown()
	if self.adb_name == nil then
		return false
	end

	local success = shutdown_android_virtual_device(self.adb_name)
	return success
end

---@param arg unknown
---@return boolean
M.is_android_virtual_device = function(arg)
	return getmetatable(arg) == AndroidVirtualDevice
end

return M
