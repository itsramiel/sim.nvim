local M = {}

local Snacks = require("snacks")
local api = require("sim.api")
local models = require("sim.api.models")

local coroutines = require("sim.utils").coroutines

local function get_icon_for_device(device)
	if models.IOSVirtualDevice.is_ios_virtual_device(device) then
		return ""
	elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
		return ""
	else
		return nil
	end
end

local function show_devices_picker()
	Snacks.picker({
		finder = function(_, ctx)
			return function(callback)
				local is_ios_done = false
				local is_android_done = false

				local function resume_if_done()
					if is_ios_done and is_android_done then
						ctx.async:resume()
					end
				end

				local ios_virtual_proc = api.get_ios_virtual_devices(function(devices)
					for _, device in ipairs(devices) do
						---@type snacks.picker.finder.Item
						local item = {
							text = device.name,
							device = device,
						}
						callback(item)
					end
					is_ios_done = true

					resume_if_done()
				end)

				local android_virtual_proc = api.get_android_virtual_devices(function(devices)
					for _, device in ipairs(devices) do
						---@type snacks.picker.finder.Item
						local item = {
							text = device.name,
							device = device,
						}
						callback(item)
					end

					is_android_done = true
					resume_if_done()
				end)

				ctx.async:on("abort", function()
					if ios_virtual_proc ~= nil then
						ios_virtual_proc:kill("sigterm")
					end

					if android_virtual_proc ~= nil then
						android_virtual_proc:kill("sigterm")
					end
				end)
				ctx.async:suspend()
			end
		end,
		format = function(item, _)
			local name = item.text
			local icon = get_icon_for_device(item.device)

			local text = icon .. " " .. name

			return {
				{ text },
			}
		end,
		layout = { preset = "select" },
	})
end

M.setup = function()
	M.show_devices_picker = show_devices_picker
end

return M
