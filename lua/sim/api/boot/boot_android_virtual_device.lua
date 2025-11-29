local coop = require("coop")
local cvim = require("coop.vim")
local coop_utils = require("coop.uv-utils")
local executables = require("sim.api.executables")
local get_booted_android_emulator_names = require("sim.api.get_booted_android_emulator_names")

---async
---@param avd_name string
---@return string?
local function boot_android_virtual_device(avd_name)
  if executables.emulator == nil then
    return nil
  end

  coop.spawn(function()
    cvim.system({ executables.emulator, "-avd", avd_name }, { detach = true })
  end)

  for i = 1, 30 do
    local booted_android_emulator_names = get_booted_android_emulator_names()
    local adb_name = booted_android_emulator_names[avd_name]
    if adb_name ~= nil then
      print("gottem")
      return adb_name
    else
      coop_utils.sleep(100)
    end
  end
  print("yo")

  return nil
end

return boot_android_virtual_device
