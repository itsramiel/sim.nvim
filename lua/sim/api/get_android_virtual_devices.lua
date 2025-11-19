local string_lib = require("sim.utils").string
local executables = require("sim.api.executables")
local AndroidVirtualDevice = require("sim.api.models").AndroidVirtualDevice

---@param callback (fun(devices: AndroidVirtualDevice[]): nil)
local function get_android_virtual_devices(callback)
  print("calling android")

  ---@type AndroidVirtualDevice[]
  local devices = {}

  if executables.emulator == nil then
    callback(devices)
    return
  end
  print("still on it")

  return vim.system({ executables.emulator, "-list-avds" }, {}, function(out)
    vim.schedule(function()
      print("done")
      print("code: " .. out.code)
      if out.code ~= 0 then
        callback(devices)
        return
      end

      local output = out.stdout

      if output == nil or #output == 0 then
        callback(devices)
        return
      end

      for line in string_lib.lines(output) do
        if #line == 0 then
          goto continue
        end

        local device = AndroidVirtualDevice.new(line, false)

        table.insert(devices, device)
        ::continue::
      end

      callback(devices)
    end)
  end)
end

return get_android_virtual_devices
