local M = {}
local json = require("sim.utils").json
local Device = require("sim.models").Device
local executables = require("sim.utils").executables
local string_lib = require("sim.utils").string

---@return Device[]
function M:get_ios_simulators()
  local devices = {}

  if executables.xcrun == nil then
    return devices
  end

  local out = vim.system({ executables.xcrun, "simctl", "list", "devices", "available", "-j" }, nil):wait()
  if out.code ~= 0 then
    return devices
  end

  local output = out.stdout

  if output == nil or output == "" then
    return devices
  end
  local parsedDevices = json.parse(output).devices

  for key, devices_array in pairs(parsedDevices) do
    local unparsed_os = string.match(key, "([^%.]+)$")
    local os, major, minor = string.match(unparsed_os, "(%w+)-(%d+)-(%d+)")

    for _, device in ipairs(devices_array) do
      local is_device_available = device.isAvailable
      if not is_device_available then
        print("device is not available")
        goto continue
      end

      local device_name = device.name
      local device_udid = device.udid
      local device_state = device.state

      table.insert(devices, Device:new(device_name, device_udid, device_state, os, major .. "." .. minor))
      ::continue::
    end
  end

  return devices
end

---@param callback (fun(devices: string[]): nil)
function M:get_android_emulators(callback)
  local device_names = {}

  local emulator_path = executables.emulator
  if emulator_path == nil then
    return device_names
  end

  vim.system({ emulator_path, "-list-avds" }, {}, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        callback(device_names)
        return
      end

      local output = out.stdout

      if output == nil or #output == 0 then
        callback(device_names)
        return
      end

      for line in string_lib.lines(output) do
        if #line == 0 then
          goto continue
        end

        table.insert(device_names, line)
        ::continue::
      end

      callback(device_names)
    end)
  end)
end

return M
