local cvim = require("coop.vim")
local string_lib = require("sim.utils").string
local executables = require("sim.api.executables")
local android_model = require("sim.api.models.AndroidVirtualDevice")
local get_booted_android_emulator_names = require("sim.api.get_booted_android_emulator_names")

---@async
---@return AndroidVirtualDevice[]
local function get_android_virtual_devices()
	local booted_emulators = get_booted_android_emulator_names()

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

		local emulator_name = line
		local adb_name = booted_emulators[emulator_name]

		local device = android_model.AndroidVirtualDevice:new(emulator_name, adb_name)

		table.insert(devices, device)
		::continue::
	end

	return devices
end

return get_android_virtual_devices
