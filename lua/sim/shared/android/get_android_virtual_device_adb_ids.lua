local string_lib = require("sim.shared.string")
local executables = require("sim.shared.executables")

local cvim = require("coop.vim")

---@async
---@return table<string, boolean>
local function get_android_virtual_device_adb_ids()
  ---@type table<string, boolean>
  local adb_ids = {}

  if executables.adb == nil then
    return adb_ids
  end

  local out = cvim.system({ executables.adb, "devices" })

  if out.code ~= 0 then
    return adb_ids
  end

  local output = out.stdout

  if output == nil or #output == 0 then
    return adb_ids
  end

  for line in string_lib.lines(output) do
    local adb_name = string.match(line, "^emulator%-%d+")
    if type(adb_name) == "string" then
      adb_ids[adb_name] = true
    end
  end

  return adb_ids
end

return get_android_virtual_device_adb_ids
