local M = {}

M.setup = function()
	local executables = require("sim.api.executables")
	executables.setup()

	M.get_ios_virtual_devices = require("sim.api.get_ios_virtual_devices")

	M.get_android_virtual_devices = require("sim.api.get_android_virtual_devices")
end

return M
