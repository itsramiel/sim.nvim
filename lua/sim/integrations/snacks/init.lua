local M = {}

local coop = require("coop")
local Snacks = require("snacks")
local api = require("sim.api")
local models = require("sim.api.models")
local boot = require("sim.api.boot")
local shutdown = require("sim.api.shutdown")

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
		show_ios = true,
		show_android = true,
		finder = function(opts, ctx)
			return function(callback)
				coop.spawn(function()
					local ios_task = coop.spawn(function()
						local show_ios = opts.show_ios
						if show_ios == false then
							return
						end
						local devices = api.get_ios_virtual_devices()

						for _, device in ipairs(devices) do
							---@type snacks.picker.finder.Item
							local item = {
								text = device.name,
								device = device,
							}
							callback(item)
						end
					end)

					local android_task = coop.spawn(function()
						local show_android = opts.show_android
						if show_android == false then
							return
						end
						local devices = api.get_android_virtual_devices()
						for _, device in ipairs(devices) do
							---@type snacks.picker.finder.Item
							local item = {
								text = device.name,
								device = device,
							}
							callback(item)
						end
					end)

					ctx.async:on("abort", function()
						if ios_task:is_cancelled() == false then
							ios_task:cancel()
						end
						if android_task:is_cancelled() == false then
							android_task:cancel()
						end
					end)

					ios_task:await()
					android_task:await()
					ctx.async:resume()
				end)

				ctx.async:suspend()
			end
		end,
		format = function(item, _)
			local name = item.text
			local icon = get_icon_for_device(item.device)
			local booted = false

			local device = item.device

			if models.IOSVirtualDevice.is_ios_virtual_device(device) then
				---@cast device IOSVirtualDevice
				booted = device.state == "Booted"
			elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
				---@cast device AndroidVirtualDevice
				booted = device.adb_name ~= nil
			end

			local text = icon .. "  " .. name
			if booted then
				text = text .. " ✅"
			end

			return {
				{ text },
			}
		end,
		toggles = {
			show_ios = "I",
			show_android = "A",
		},
		actions = {
			boot = function(self, item)
				coop.spawn(function()
					local device = item.device
					local success = boot.boot_device(device)
					if success then
						self:refresh()
					end
				end)
			end,
			shutdown = function(self, item)
				coop.spawn(function()
					local device = item.device
					local success = shutdown.shutdown_device(device)

					if success then
						self:refresh()
					end
				end)
			end,
		},
		win = {
			input = {
				keys = {
					["<C-b>"] = { "boot", mode = { "n", "i" } },
					["<C-x>"] = { "shutdown", mode = { "n", "i" } },
					["<C-i>"] = { "toggle_show_ios", mode = { "n", "i" } },
					["<C-a>"] = { "toggle_show_android", mode = { "n", "i" } },
				},
			},
		},
		layout = { preset = "select" },
	})
end

M.setup = function()
	M.show_devices_picker = show_devices_picker
end

return M
