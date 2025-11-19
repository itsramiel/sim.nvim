local DeviceService = {}

---@param udid string
---@param callback (fun(success: boolean): nil)?
function DeviceService:boot(udid, callback)
  vim.system({ "xcrun", "simctl", "boot", udid }, nil, function(out)
    vim.schedule(function()
      if callback ~= nil then
        callback(out.code == 0)
      end
    end)
  end)
end

---@param udid string
---@param callback (fun(success: boolean): nil)?
function DeviceService:shutdown(udid, callback)
  vim.system({ "xcrun", "simctl", "shutdown", udid }, nil, function(out)
    vim.schedule(function()
      if callback ~= nil then
        callback(out.code == 0)
      end
    end)
  end)
end

return DeviceService
