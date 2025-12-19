local cvim = require("coop.vim")

local paste_to_android_device = require("sim.api.paste").paste_to_android_device

local string_lib = require("sim.shared.string")
local clipboard = require("sim.shared.clipboard")
local executables = require("sim.shared.executables")

---@class sim.api.models.android_physical_device
---@field name string
---@field adb_id string?
local android_physical_device = {}

---@param name string
---@param adb_id string?
---@return sim.api.models.android_physical_device
function android_physical_device:new(name, adb_id)
  ---@type sim.api.models.android_physical_device
  local device = {
    name = name,
    adb_id = adb_id,
  }

  self.__index = self

  setmetatable(device, self)

  return device
end

---@async
---@return sim.api.models.android_physical_device[]
function android_physical_device.get()
  ---@type sim.api.models.android_physical_device[]
  local devices = {}

  if executables.adb == nil then
    return devices
  end

  local out = cvim.system({ executables.adb, "devices", "-l" }, { detach = true })

  if out.code ~= 0 then
    return devices
  end

  local output = out.stdout

  if output == nil or #output == 0 then
    return devices
  end

  for line in string_lib.lines(output) do
    if #line == 0 then
      goto continue
    end

    local adb_id = string.match(line, "^([^%s]+)%s*")
    local name = string.match(line, "model:([^%s]+)%s*")

    if not adb_id or not name or #adb_id == 0 or #name == 0 then
      goto continue
    end

    if string.find(adb_id, "emulator") then
      goto continue
    end

    local device = android_physical_device:new(name, adb_id)

    table.insert(devices, device)
    ::continue::
  end

  return devices
end

function android_physical_device:copy_name()
  local name = self.name
  clipboard.copy_to_clipboard(name)

  return name
end

function android_physical_device:copy_adb_id()
  local adb_id = self.adb_id
  if adb_id == nil then
    return
  end

  clipboard.copy_to_clipboard(adb_id)

  return adb_id
end

---@return string?
function android_physical_device:paste_machine_clipboard()
  local adb_id = self.adb_id
  if adb_id == nil then
    return nil
  end

  local clipboard_content = vim.fn.getreg("+")

  local success = paste_to_android_device(adb_id, clipboard_content)

  return success and clipboard_content or nil
end

return android_physical_device
