local M = {}

M.shutdown_device = require("sim.api.shutdown.shutdown_device")
M.shutdown_ios_virtual_device = require("sim.api.shutdown.shutdown_ios_virtual_device")
M.shutdown_android_virtual_device = require("sim.api.shutdown.shutdown_android_virtual_device")

return M
