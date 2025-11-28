local cvim = require("coop.vim")
local coop_utils = require("coop.uv-utils")
local executables = require("sim.api.executables")
local get_android_virtual_device_adb_ids = require("sim.api.get_android_virtual_device_adb_ids")

---@async
---@param adb_name string
---@return boolean
local function shutdown_android_virtual_device(adb_name)
  if executables.adb == nil then
    return false
  end

  local out = cvim.system({ executables.adb, "-s", adb_name, "emu", "kill" }, nil)

  if out.code ~= 0 then
    return false
  end

  for i = 1, 20 do
    local booted_adb_ids = get_android_virtual_device_adb_ids()
    if booted_adb_ids[adb_name] then
      coop_utils.sleep(250)
    else
      return true
    end
  end

  return false
end

return shutdown_android_virtual_device
