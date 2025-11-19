local M = {}

M.setup = function()
  local api = require("sim.api")
  api.setup()

  local integrations = require("sim.integrations")
  integrations.snacks.setup()

  vim.api.nvim_create_user_command("SimSelect", function(_)
    integrations.snacks.show_devices_picker()
  end, {})
end

return M
