local M = {}

local coop = require("coop")
local cvim_ui = require("coop.ui")

local sim_api = require("sim.api")
local notify = require("sim.shared.notify")
local table_lib = require("sim.shared.table_lib")

---@alias sim.ui.list_action<T>  { label: string, fn: (fun(item: T): nil) }

---@async
---@generic T
---@param items T[]
---@param format_item fun(item: T): string
---@param prompt string
---@return T?
local function select(items, format_item, prompt)
	return cvim_ui.select(items, {
		format_item = function(item)
			return format_item(item)
		end,
		prompt = prompt,
	})
end

function M.list_android_virtual_devices()
	coop.spawn(function()
		---@alias sim.ui.list_action.android_virtual_device sim.ui.list_action<sim.api.models.android_virtual_device>

		---@param is_booted boolean
		---@return sim.ui.list_action.android_virtual_device[]
		local function get_actions(is_booted)
			---@type sim.ui.list_action.android_virtual_device[]
			local common_actions = {
				{
					label = "Copy name",
					fn = function(device)
						local copied_name = device:copy_name()
						vim.notify(copied_name .. " copied to clipboard ✅")
					end,
				},
			}

			---@type sim.ui.list_action.android_virtual_device[]
			local booted_actions = {
				{
					label = "Copy adb id",
					fn = function(device)
						local copied_adb_id = device:copy_adb_id()
						if copied_adb_id ~= nil then
							vim.notify(copied_adb_id .. " copied to clipboard ✅")
						end
					end,
				},
				{
					label = "Shutdown",
					fn = function(device)
						device:shutdown()
					end,
				},
				{
					label = "Paste machine clipboard to device",
					fn = function(device)
						local pasted = device:paste_machine_clipboard()
						if pasted ~= nil then
							vim.notify("Machine clibpoard pasted successfully")
						end
					end,
				},
			}

			---@type sim.ui.list_action.android_virtual_device[]
			local not_booted_actions = {
				{
					label = "Boot",
					fn = function(device)
						device:boot()
					end,
				},
				{
					label = "Cold boot",
					fn = function(device)
						device:boot({ cold = true })
					end,
				},
			}

			if is_booted then
				return table_lib.merge(common_actions, booted_actions)
			else
				return table_lib.merge(common_actions, not_booted_actions)
			end
		end

		notify(string.format("Getting android virtual devices"))
		local devices = sim_api.models.android_virtual_device.get()

		if #devices == 0 then
			notify("No android virtual devices found")
			return
		end

		local device = select(devices, function(item)
			local name = item.name
			if item:isBooted() then
				name = name .. " ✅"
			end
			return name
		end, "Select Android Virtual Device to perform an action on")

		if device == nil then
			return
		end

		local actions = get_actions(device:isBooted())

		local action = select(actions, function(item)
			return item.label
		end, "Select action")

		if action == nil then
			return
		end

		action.fn(device)
	end)
end

function M.list_ios_virtual_devices()
	coop.spawn(function()
		---@alias sim.ui.list_action.ios_virtual_device sim.ui.list_action<sim.api.models.ios_virtual_device>

		---@param is_booted boolean
		---@return sim.ui.list_action.ios_virtual_device[]
		local function get_actions(is_booted)
			---@type sim.ui.list_action.ios_virtual_device[]
			local common_actions = {
				{
					label = "Copy name",
					fn = function(device)
						local copied_name = device:copy_name()
						vim.notify(copied_name .. " copied to clipboard ✅")
					end,
				},
				{
					label = "Copy UDID",
					fn = function(device)
						local copied_name = device:copy_udid()
						vim.notify(copied_name .. " copied to clipboard ✅")
					end,
				},
			}

			---@type sim.ui.list_action.ios_virtual_device[]
			local booted_actions = {
				{
					label = "Shutdown",
					fn = function(device)
						device:shutdown()
					end,
				},
			}

			---@type sim.ui.list_action.ios_virtual_device[]
			local not_booted_actions = {
				{
					label = "Boot",
					fn = function(device)
						device:boot()
					end,
				},
			}

			if is_booted then
				return table_lib.merge(common_actions, booted_actions)
			else
				return table_lib.merge(common_actions, not_booted_actions)
			end
		end

		notify(string.format("Getting iOS virtual devices"))
		local devices = sim_api.models.ios_virtual_device.get()

		if #devices == 0 then
			notify("No iOS virtual devices found")
			return
		end

		local device = select(devices, function(item)
			local name = item.name
			if item:isBooted() then
				name = name .. " ✅"
			end
			return name
		end, "Select iOS Virtual Device to perform an action on")

		if device == nil then
			return
		end

		local actions = get_actions(device:isBooted())

		local action = select(actions, function(item)
			return item.label
		end, "Select action")

		if action == nil then
			return
		end

		action.fn(device)
	end)
end

function M.list_ios_physical_devices()
	coop.spawn(function()
		---@alias sim.ui.list_action.ios_physical_device sim.ui.list_action<sim.api.models.ios_physical_device>

		---@return sim.ui.list_action.ios_physical_device[]
		local function get_actions()
			---@type sim.ui.list_action.ios_physical_device[]
			local common_actions = {
				{
					label = "Copy name",
					fn = function(device)
						local copied_name = device:copy_name()
						vim.notify(copied_name .. " copied to clipboard ✅")
					end,
				},
				{
					label = "Copy UDID",
					fn = function(device)
						local copied_name = device:copy_udid()
						vim.notify(copied_name .. " copied to clipboard ✅")
					end,
				},
			}

			return common_actions
		end

		notify(string.format("Getting iOS physical devices"))
		local devices = sim_api.models.ios_physical_device.get()

		if #devices == 0 then
			notify("No iOS physical devices found")
			return
		end

		local device = select(devices, function(item)
			return item:get_display_name()
		end, "Select iOS device to perform an action on")

		if device == nil then
			return
		end

		local actions = get_actions()

		local action = select(actions, function(item)
			return item.label
		end, "Select action")

		if action == nil then
			return
		end

		action.fn(device)
	end)
end

return M
