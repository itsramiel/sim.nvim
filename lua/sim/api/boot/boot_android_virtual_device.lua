local coop = require("coop")
local cvim = require("coop.vim")
local coop_utils = require("coop.uv-utils")

local executables = require("sim.shared.executables")
local table_lib = require("sim.shared.table_lib")
local get_booted_android_emulator_names = require("sim.shared.android").get_booted_android_emulator_names

---@alias sim.api.boot_android_virtual_device.opts {cold:boolean?, no_audio: boolean?}

---async
---@param avd_name string
---@param opts sim.api.boot_android_virtual_device.opts?
---@return string?
local function boot_android_virtual_device(avd_name, opts)
  opts = opts or {}

  if executables.emulator == nil then
    return nil
  end

  local boot_command = { executables.emulator, "-avd", avd_name }

  local flags = {}

  if opts.cold then
    table.insert(flags, "-no-snapshot-load")
  end
  if opts.no_audio then
    table.insert(flags, "-no-audio")
  end

  local command = table_lib.merge(boot_command, flags)

  coop.spawn(function()
    cvim.system(command, { detach = true })
  end)

  for _ = 1, 30 do
    local booted_android_emulator_names = get_booted_android_emulator_names()
    local adb_name = booted_android_emulator_names[avd_name]
    if adb_name ~= nil then
      return adb_name
    else
      coop_utils.sleep(100)
    end
  end

  return nil
end

return boot_android_virtual_device
