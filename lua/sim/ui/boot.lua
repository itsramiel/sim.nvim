local M = {}

local coop = require("coop")
local cvim_ui = require("coop.ui")
local notify = require("sim.shared.notify")
local sim_api = require("sim.api")

---@async
function M.boot_ios_virtual_device()
	coop.spawn(function()
		---@param device sim.api.models.ios_virtual_device
		local function boot(device)
			notify(string.format("Booting iOS virtual device '%s'", device.name))
			local success = device:boot()
			if success then
				notify(string.format("Booted iOS virtual device '%s' successfully", device.name))
			else
				notify(string.format("Failed to boot iOS virtual device '%s'", device.name))
			end
		end

		notify("Getting iOS virtual devices")
		local devices = sim_api.models.ios_virtual_device.get()
		local first_device = devices[1]

		if first_device == nil then
			notify("No iOS virtual devices found")
		elseif #devices == 1 then
			boot(first_device)
		else
			---@type sim.api.models.ios_virtual_device
			local device = cvim_ui.select(devices, {
				prompt = "Select iOS virtual device to boot",
				---@param item sim.api.models.ios_virtual_device
				format_item = function(item)
					local name = item.name
					if item:isBooted() then
						name = name .. " ✅"
					end
					return name
				end,
			})

			boot(device)
		end
	end)
end

---@async
function M.boot_android_virtual_device()
	coop.spawn(function()
		---@param device sim.api.models.android_virtual_device
		local function boot(device)
			notify(string.format("Booting android virtual device '%s'", device.name))
			local success = device:boot()
			if success then
				notify(string.format("Booted android virtual device '%s' successfully", device.name))
			else
				notify(string.format("Failed to boot android virtual device '%s'", device.name))
			end
		end

		notify(string.format("Getting android virtual devices"))
		local devices = sim_api.models.android_virtual_device.get()
		local first_device = devices[1]

		if first_device == nil then
			notify("No android virtual devices found")
		elseif #devices == 1 then
			boot(first_device)
		else
			---@type sim.api.models.android_virtual_device
			local device = cvim_ui.select(devices, {
				prompt = "Select Android virtual device to boot",
				---@param item sim.api.models.ios_virtual_device
				format_item = function(item)
					local name = item.name
					if item:isBooted() then
						name = name .. " ✅"
					end
					return name
				end,
			})

			boot(device)
		end
	end)
end

return M
