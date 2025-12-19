local cvim = require("coop.vim")

local string_lib = require("sim.shared.string")
local executables = require("sim.shared.executables")
local clipboard = require("sim.shared.clipboard")

local get_booted_android_emulator_names = require("sim.shared.android").get_booted_android_emulator_names
local boot_android_virtual_device = require("sim.api.boot.boot_android_virtual_device")
local shutdown_android_virtual_device = require("sim.api.shutdown.shutdown_android_virtual_device")
local paste_to_android_device = require("sim.api.paste").paste_to_android_device

---@class sim.api.models.android_virtual_device
---@field name string
---@field adb_name string?
local android_virtual_device = {}

---@param name string
---@param adb_name string?
---@return sim.api.models.android_virtual_device
function android_virtual_device:new(name, adb_name)
  ---@type sim.api.models.android_virtual_device
  local device = {
    name = name,
    adb_name = adb_name,
  }

  self.__index = self

  setmetatable(device, self)

  return device
end

---@return boolean
function android_virtual_device:isBooted()
  return self.adb_name ~= nil
end

---@param opts sim.api.boot_android_virtual_device.opts?
---@return boolean
function android_virtual_device:boot(opts)
  local adb_id = boot_android_virtual_device(self.name, opts)
  self.adb_name = adb_id

  return adb_id ~= nil
end

function android_virtual_device:copy_name()
  local name = self.name
  clipboard.copy_to_clipboard(name)

  return name
end

function android_virtual_device:copy_adb_id()
  local adb_id = self.adb_name
  if adb_id == nil then
    return
  end

  clipboard.copy_to_clipboard(adb_id)

  return adb_id
end

---Copies machine clipboard to device
---@return string?
function android_virtual_device:paste_machine_clipboard()
  local adb_id = self.adb_name
  if adb_id == nil then
    return nil
  end

  local clipboard_content = vim.fn.getreg("+")

  local success = paste_to_android_device(adb_id, clipboard_content)

  return success and clipboard_content or nil
end

---@return boolean
function android_virtual_device:shutdown()
  if self.adb_name == nil then
    return false
  end

  local success = shutdown_android_virtual_device(self.adb_name)
  return success
end

---@async
---@return sim.api.models.android_virtual_device[]
function android_virtual_device.get()
  local booted_emulators = get_booted_android_emulator_names()

  ---@type sim.api.models.android_virtual_device[]
  local devices = {}

  if executables.emulator == nil then
    return devices
  end

  local out = cvim.system({ executables.emulator, "-list-avds" }, { detach = true })

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

    local emulator_name = line
    local adb_name = booted_emulators[emulator_name]

    local device = android_virtual_device:new(emulator_name, adb_name)

    table.insert(devices, device)
    ::continue::
  end

  return devices
end

return android_virtual_device
