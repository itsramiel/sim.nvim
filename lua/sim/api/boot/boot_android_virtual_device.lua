local executables = require("sim.api.executables")

---@param avd_name string
---@param callback (fun(success: boolean): nil)?
local function boot_android_virtual_device(avd_name, callback)
	if executables.emulator == nil then
		if callback ~= nil then
			callback(false)
		end
		return
	end

	vim.system({ executables.emulator, "-avd", avd_name }, nil, function(out)
		vim.schedule(function()
			if callback ~= nil then
				callback(out.code == 0)
			end
		end)
	end)
end

return boot_android_virtual_device
