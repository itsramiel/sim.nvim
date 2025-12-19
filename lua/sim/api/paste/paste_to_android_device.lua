local cvim = require("coop.vim")
local executables = require("sim.shared.executables")

---async
---@param adb_id string
---@param str string
---@return boolean
local function paste_to_android_device(adb_id, str)
  if executables.adb == nil then
    return false
  end

  local out = cvim.system(
    { executables.adb, "-s", adb_id, "shell", "input", "text", string.format("'%s'", str) },
    { detach = true }
  )

  return out.code == 0
end

return paste_to_android_device
