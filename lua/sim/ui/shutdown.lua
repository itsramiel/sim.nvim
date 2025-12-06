local M = {}

local coop = require("coop")
local cvim_ui = require("coop.ui")

local sim_api = require("sim.api")
local notify = require("sim.shared.notify")

---@async
function M.shutdown_ios_virtual_device()
	coop.spawn(function()
		---@async
		---@param device sim.api.models.ios_virtual_device
		local function shutdown(device)
			notify(string.format("Shutting down iOS virtual device '%s'", device.name))
			local success = device:shutdown()
			if success then
				notify(string.format("iOS virtual device '%s' successfully shutdown", device.name))
			else
				notify(string.format("Failed to shutdown iOS virtual device '%s'", device.name))
			end
		end

		notify("Getting booted iOS virtual devices")
		local devices = sim_api.models.ios_virtual_device.get()
		---@type sim.api.models.ios_virtual_device[]
		local booted_devices = {}

		for _, device in ipairs(devices) do
			if device:isBooted() then
				table.insert(booted_devices, device)
			end
		end

		local first_device = booted_devices[1]

		if first_device == nil then
			notify("There are no booted iOS virtual devices")
		elseif #booted_devices == 1 then
			shutdown(first_device)
		else
			---@type sim.api.models.ios_virtual_device
			local device = cvim_ui.select(booted_devices, {
				prompt = "Select iOS virtual device to shutdown",
				---@param item sim.api.models.ios_virtual_device
				format_item = function(item)
					return item.name
				end,
			})

			shutdown(device)
		end
	end)
end

---@async
function M.shutdown_android_virtual_device()
	coop.spawn(function()
		---@async
		---@param device sim.api.models.android_virtual_device
		local function shutdown(device)
			notify(string.format("Shutting down android virtual device %s", device.name))
			local success = device:shutdown()
			if success then
				notify(string.format("Android virtual device '%s' successfully shutdown", device.name))
			else
				notify(string.format("Failed to shutdown android virtual device '%s'", device.name))
			end
		end

		notify("Getting booted android virtual devices")
		local devices = sim_api.models.android_virtual_device.get()
		---@type sim.api.models.android_virtual_device[]
		local booted_devices = {}

		for _, device in ipairs(devices) do
			if device:isBooted() then
				table.insert(booted_devices, device)
			end
		end

		local first_device = booted_devices[1]

		if first_device == nil then
			notify("There are no booted android virtual devices")
		elseif #booted_devices == 1 then
			shutdown(first_device)
		else
			---@type sim.api.models.android_virtual_device
			local device = cvim_ui.select(booted_devices, {
				prompt = "Select android virtual device to shutdown",
				---@param item sim.api.models.android_virtual_device
				format_item = function(item)
					return item.name
				end,
			})

			shutdown(device)
		end
	end)
end

function M.shutdown_all_virtual_devices()
	coop.spawn(function()
		notify("Shutting down all android virtual devices")
		local succes = sim_api.shutdown.shutdown_all_android_virtual_devices()
		if succes then
			notify("All android virtual devices successfully shutdown")
		else
			notify("Failed to shutdown all android virtual devices")
		end
	end)

	coop.spawn(function()
		notify("Shutting down all ios virtual devices")
		local succes = sim_api.shutdown.shutdown_all_ios_virtual_devices()
		if succes then
			notify("All ios virtual devices successfully shutdown")
		else
			notify("Failed to shutdown all ios virtual devices")
		end
	end)
end

return M
