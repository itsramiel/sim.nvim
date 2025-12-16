local cvim = require("coop.vim")

local string_lib = require("sim.shared.string")
local executables = require("sim.shared.executables")
local get_android_virtual_device_adb_ids = require("sim.shared.android.get_android_virtual_device_adb_ids")

---@alias get_booted_android_emulator_names_result table<string, string>

---@async
---@return get_booted_android_emulator_names_result
local function get_booted_android_emulator_names()
  ---@type get_booted_android_emulator_names_result
  local booted_emulators = {}

  local adb_ids = get_android_virtual_device_adb_ids()

  for adb_id, _ in pairs(adb_ids) do
    local avd_name_out = cvim.system({ executables.adb, "-s", adb_id, "emu", "avd", "name" }, { detach = true })
    if avd_name_out.code ~= 0 or avd_name_out.stdout == nil or #avd_name_out.stdout == 0 then
      goto continue
    end

    local emulator_name = string_lib.lines(avd_name_out.stdout)()
    if #emulator_name == 0 then
      goto continue
    end

    booted_emulators[emulator_name] = adb_id
    ::continue::
  end

  return booted_emulators
end

return get_booted_android_emulator_names
