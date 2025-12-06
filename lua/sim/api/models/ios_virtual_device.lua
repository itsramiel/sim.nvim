local cvim = require("coop.vim")

local json = require("sim.shared.json")
local executables = require("sim.shared.executables")
local clipboard = require("sim.shared.clipboard")

local boot_ios_virtual_device = require("sim.api.boot.boot_ios_virtual_device")
local shutdown_ios_virtual_device = require("sim.api.shutdown.shutdown_ios_virtual_device")

---@class sim.api.models.ios_virtual_device
---@field name string
---@field udid string
---@field state "Shutdown" | "Booted"
---@field os string
---@field version string
local ios_virtual_device = {}

---@param name string
---@param udid string
---@param state string
---@param os string
---@param version string
---@return sim.api.models.ios_virtual_device
function ios_virtual_device:new(name, udid, state, os, version)
	---@type sim.api.models.ios_virtual_device
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

function ios_virtual_device:isBooted()
	return self.state == "Booted"
end

---@async
function ios_virtual_device:boot()
	local success = boot_ios_virtual_device(self.udid)
	if success then
		self.state = "Booted"
	end
end

---@async
function ios_virtual_device:shutdown()
	local success = shutdown_ios_virtual_device(self.udid)
	if success then
		self.state = "Shutdown"
	end

	return success
end

function ios_virtual_device:copy_name()
	local name = self.name
	clipboard.copy_to_clipboard(name)

	return name
end

function ios_virtual_device:copy_udid()
	local udid = self.udid
	clipboard.copy_to_clipboard(udid)

	return udid
end

---@return sim.api.models.ios_virtual_device[]
function ios_virtual_device.get()
	local devices = {}

	if executables.xcrun == nil then
		return devices
	end

	local out = cvim.system({ executables.xcrun, "simctl", "list", "devices", "available", "-j" })

	if out.code ~= 0 then
		return devices
	end

	local output = out.stdout

	if output == nil or output == "" then
		return devices
	end

	local parsedDevices = json.parse(output).devices

	for key, devices_array in pairs(parsedDevices) do
		local unparsed_os = string.match(key, "([^%.]+)$")
		local os, major, minor = string.match(unparsed_os, "(%w+)-(%d+)-(%d+)")

		for _, device in ipairs(devices_array) do
			local is_device_available = device.isAvailable
			if not is_device_available then
				goto continue
			end

			local device_name = device.name
			local device_udid = device.udid
			local device_state = device.state

			table.insert(
				devices,
				ios_virtual_device:new(device_name, device_udid, device_state, os, major .. "." .. minor)
			)
			::continue::
		end
	end

	return devices
end

return ios_virtual_device
