local M = {}

local coop = require("coop")
local Snacks = require("snacks")
local api = require("sim.api")
local models = require("sim.api.models")
local boot = require("sim.api.boot")
local shutdown = require("sim.api.shutdown")

local function get_icon_for_device(device)
  if models.IOSVirtualDevice.is_ios_virtual_device(device) then
    return ""
  elseif models.AndroidVirtualDevice.is_android_virtual_device(device) then
    return ""
  else
    return nil
  end
end

local function show_devices_picker()
  Snacks.picker({
    finder = function(_, ctx)
      return function(callback)
        coop.spawn(function()
          local ios_task = coop.spawn(function()
            local devices = api.get_ios_virtual_devices()

            for _, device in ipairs(devices) do
              ---@type snacks.picker.finder.Item
              local item = {
                text = device.name,
                device = device,
              }
              callback(item)
            end
          end)

          local android_task = coop.spawn(function()
            local devices = api.get_android_virtual_devices()
            for _, device in ipairs(devices) do
              ---@type snacks.picker.finder.Item
              local item = {
                text = device.name,
                device = device,
              }
              callback(item)
            end
          end)

          ctx.async:on("abort", function()
            if ios_task:is_cancelled() == false then
              ios_task:cancel()
            end
            if android_task:is_cancelled() == false then
              android_task:cancel()
            end
          end)

          ios_task:await()
          android_task:await()
          ctx.async:resume()
        end)

        ctx.async:suspend()
      end
    end,
    format = function(item, _)
      local name = item.text
      local icon = get_icon_for_device(item.device)

      local text = icon .. "  " .. name

      return {
        { text },
      }
    end,
    actions = {
      boot = function(self, item)
        local device = item.device
        boot.boot_device(device, function(success)
          if success then
            self:refresh()
          end
        end)
      end,
      shutdown = function(self, item)
        local device = item.device
        shutdown.shutdown_device(device, function(success)
          if success then
            self:refresh()
          end
        end)
      end,
    },
    win = {
      input = {
        keys = {
          ["<C-b>"] = { "boot", mode = { "n", "i" } },
          ["<C-x>"] = { "shutdown", mode = { "n", "i" } },
        },
      },
    },
    layout = { preset = "select" },
  })
end

M.setup = function()
  M.show_devices_picker = show_devices_picker
end

return M
