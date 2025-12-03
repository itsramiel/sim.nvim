local coop = require("coop")
local coop_control = require("coop.control")

local get_android_virtual_device_adb_ids = require("sim.shared.android").get_android_virtual_device_adb_ids
local shutdown_android_virtual_device = require("sim.api.shutdown.shutdown_android_virtual_device")

---@async
local function shutdown_all_android_virtual_devices()
  local adb_ids = get_android_virtual_device_adb_ids()

  if adb_ids == nil then
    return false
  end

  ---@type Coop.Task[]
  local tasks = {}
  for adb_id, _ in pairs(adb_ids) do
    tasks[#tasks + 1] = coop.spawn(function()
      return shutdown_android_virtual_device(adb_id)
    end)
  end

  coop_control.await_all(tasks)

  return true
end

return shutdown_all_android_virtual_devices
