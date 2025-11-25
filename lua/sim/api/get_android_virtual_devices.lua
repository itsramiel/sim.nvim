local cvim = require("coop.vim")
local string_lib = require("sim.utils").string
local executables = require("sim.api.executables")
local AndroidVirtualDevice = require("sim.api.models").AndroidVirtualDevice

---@async
---@return AndroidVirtualDevice[]
local function get_android_virtual_devices()
	---@type AndroidVirtualDevice[]
	local devices = {}

	if executables.emulator == nil then
		return devices
	end

	local out = cvim.system({ executables.emulator, "-list-avds" })

	if out.code ~= 0 then
		return devices
	end

	local output = out.stdout

	if output == nil or #output == 0 then
		return devices
	end

	for line in string_lib.lines(output) do
		if #line == 0 then
			goto continue
		end

		local device = AndroidVirtualDevice.new(line, false)

		table.insert(devices, device)
		::continue::
	end

	return devices
end

return get_android_virtual_devices
