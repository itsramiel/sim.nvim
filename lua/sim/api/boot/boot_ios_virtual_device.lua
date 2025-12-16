local cvim = require("coop.vim")
local executables = require("sim.shared.executables")

---@async
---@param udid_or_name string
---@return boolean
local function boot_ios_virtual_device(udid_or_name)
	if executables.xcrun == nil then
		return false
	end

	local out = cvim.system({ "xcrun", "simctl", "boot", udid_or_name }, { detach = true })
	return out.code == 0
end

return boot_ios_virtual_device
