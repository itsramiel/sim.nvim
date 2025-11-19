local executables = require("sim.api.executables")

---@param udid_or_name string
---@param callback (fun(success: boolean): nil)?
local function boot_ios_virtual_device(udid_or_name, callback)
  if executables.xcrun == nil then
    if callback ~= nil then
      callback(false)
    end
    return
  end

  vim.system({ "xcrun", "simctl", "boot", udid_or_name }, nil, function(out)
    vim.schedule(function()
      if callback ~= nil then
        callback(out.code == 0)
      end
    end)
  end)
end

return boot_ios_virtual_device
