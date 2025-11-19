---@class IOSVirtualDevice
---@field name string
---@field udid string
---@field state string
---@field os string
---@field version string

local M = {}

local mt = {}

---@param name string
---@param udid string
---@param state string
---@param os string
---@param version string
---@return IOSVirtualDevice
function M.new(name, udid, state, os, version)
	local device = {}
	device.name = name
	device.udid = udid
	device.state = state
	device.os = os
	device.version = version

	setmetatable(device, mt)

	return device
end

---@param device any
---@return boolean
function M.is_ios_virtual_device(device)
	return getmetatable(device) == mt
end

return M
