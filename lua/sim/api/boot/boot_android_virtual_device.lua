local coop_utils = require("coop.uv-utils")
local executables = require("sim.api.executables")
local get_booted_android_emulator_names = require("sim.api.get_booted_android_emulator_names")

---async
---@param avd_name string
---@return  boolean
local function boot_android_virtual_device(avd_name)
	if executables.emulator == nil then
		return false
	end

	vim.system({ executables.emulator, "-avd", avd_name }, { detach = true })

	for i = 1, 30 do
		local booted_android_emulator_names = get_booted_android_emulator_names()
		if booted_android_emulator_names[avd_name] then
			return true
		else
			coop_utils.sleep(100)
		end
	end

	return false
end

return boot_android_virtual_device
