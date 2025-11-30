local boot_ios_virtual_device = require("sim.api.boot.boot_ios_virtual_device")
local shutdown_ios_virtual_device = require("sim.api.shutdown.shutdown_ios_virtual_device")
local M = {}

---@class IOSVirtualDevice
---@field name string
---@field udid string
---@field state "Shutdown" | "Booted"
---@field os string
---@field version string
local IOSVirtualDevice = {}

---@param name string
---@param udid string
---@param state string
---@param os string
---@param version string
---@return IOSVirtualDevice
function IOSVirtualDevice:new(name, udid, state, os, version)
	---@type IOSVirtualDevice
	local device = {
		name = name,
		udid = udid,
		state = state,
		os = os,
		version = version,
	}

	self.__index = self
	setmetatable(device, self)

	return device
end

function IOSVirtualDevice:isBooted()
	return self.state == "Booted"
end

---@async
function IOSVirtualDevice:boot()
	local success = boot_ios_virtual_device(self.udid)
	if success then
		self.state = "Booted"
	end
end

---
---@async
function IOSVirtualDevice:shutdown()
	local success = shutdown_ios_virtual_device(self.udid)
	if success then
		self.state = "Shutdown"
	end
end

M.IOSVirtualDevice = IOSVirtualDevice

---@param device any
---@return boolean
function M.is_ios_virtual_device(device)
	return getmetatable(device) == IOSVirtualDevice
end

return M
