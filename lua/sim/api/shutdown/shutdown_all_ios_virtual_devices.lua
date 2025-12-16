local cvim = require("coop.vim")

local executables = require("sim.shared.executables")

---@async
---@return boolean
local function shutdown_all_ios_virtual_devices()
	if executables.xcrun == nil then
		return false
	end

	local out = cvim.system({ executables.xcrun, "simctl", "shutdown", "all" }, { detach = true })

	return out.code == 0
end

return shutdown_all_ios_virtual_devices
