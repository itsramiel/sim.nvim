local cvim = require("coop.vim")

local json = require("sim.shared.json")
local clipboard = require("sim.shared.clipboard")
local executables = require("sim.shared.executables")

---@class sim.api.models.ios_physical_device
---@field name string
---@field udid string
---@field platform string
---@field version string
local ios_physical_device = {}

---@param name string
---@param udid string
---@param platform string
---@param version string
---@return sim.api.models.ios_physical_device
function ios_physical_device:new(name, udid, platform, version)
	---@type sim.api.models.ios_physical_device
	local device = {
		name = name,
		udid = udid,
		platform = platform,
		version = version,
	}

	self.__index = self
	setmetatable(device, self)

	return device
end

---@async
---@return sim.api.models.ios_physical_device[]
function ios_physical_device.get()
	local devices = {}

	if executables.xcrun == nil then
		return devices
	end

	local temp_file = vim.fn.tempname() .. ".json"

	local out = cvim.system(
		{ executables.xcrun, "devicectl", "list", "devices", "--json-output", temp_file },
		{ detach = true }
	)

	if out.code ~= 0 then
		os.remove(temp_file)
		return devices
	end

	local file = io.open(temp_file)
	if file == nil then
		os.remove(temp_file)
		return devices
	end

	local output = file:read("*a")

	file:close()
	os.remove(temp_file)

	local output_json = json.parse(output)

	if type(output_json) ~= "table" then
		return devices
	end

	local info = output_json.info

	if type(info) ~= "table" or info.outcome ~= "success" then
		return devices
	end

	local result = output_json.result
	if type(result) ~= "table" then
		return devices
	end

	local devices_json = result.devices
	if type(devices_json) ~= "table" then
		return devices
	end

	for _, device_json in ipairs(devices_json) do
		if type(device_json) ~= "table" then
			goto continue
		end

		local device_properties = device_json.deviceProperties
		local hardware_properties = device_json.hardwareProperties

		if type(device_properties) ~= "table" or type(hardware_properties) ~= "table" then
			goto continue
		end

		local name = device_properties.name
		local udid = hardware_properties.udid
		local platform = hardware_properties.platform
		local version = device_properties.osVersionNumber

		if
			type(name) ~= "string"
			or type(udid) ~= "string"
			or type(platform) ~= "string"
			or type(version) ~= "string"
		then
			goto continue
		end

		local device = ios_physical_device:new(name, udid, platform, version)
		table.insert(devices, device)
		::continue::
	end

	return devices
end

function ios_physical_device:copy_name()
	local name = self.name
	clipboard.copy_to_clipboard(name)

	return name
end

function ios_physical_device:copy_udid()
	local udid = self.udid
	clipboard.copy_to_clipboard(udid)

	return udid
end

function ios_physical_device:get_display_name()
	local name = self.name
	local platform = self.platform
	local version = self.version

	return name .. " - " .. string.format("(%s %s)", platform, version)
end

return ios_physical_device
