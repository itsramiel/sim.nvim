local cvim = require("coop.vim")
local json = require("sim.utils").json
local executables = require("sim.api.executables")
local IOSVirtualDevice = require("sim.api.models").IOSVirtualDevice

---@async
---@return IOSVirtualDevice[]
local function get_ios_virtual_devices()
  local devices = {}

  if executables.xcrun == nil then
    return devices
  end

  local out = cvim.system({ executables.xcrun, "simctl", "list", "devices", "available", "-j" })

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
        goto continue
      end

      local device_name = device.name
      local device_udid = device.udid
      local device_state = device.state

      table.insert(
        devices,
        IOSVirtualDevice.new(device_name, device_udid, device_state, os, major .. "." .. minor)
      )
      ::continue::
    end
  end

  return devices
end

return get_ios_virtual_devices
