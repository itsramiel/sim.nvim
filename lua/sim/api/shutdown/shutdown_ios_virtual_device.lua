local cvim = require("coop.vim")
local executables = require("sim.api.executables")

---@async
---@param udid_or_name string
---@return boolean
local function shutdown_ios_virtual_device(udid_or_name)
  if executables.xcrun == nil then
    return false
  end

  local out = cvim.system({ executables.xcrun, "simctl", "shutdown", udid_or_name })

  return out.code == 0
end

return shutdown_ios_virtual_device
