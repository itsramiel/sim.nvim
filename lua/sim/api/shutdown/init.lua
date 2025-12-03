local M = {}

M.shutdown_ios_virtual_device = require("sim.api.shutdown.shutdown_ios_virtual_device")
M.shutdown_android_virtual_device = require("sim.api.shutdown.shutdown_android_virtual_device")
M.shutdown_all_android_virtual_devices = require("sim.api.shutdown.shutdown_all_android_virtual_devices")
M.shutdown_all_ios_virtual_devices = require("sim.api.shutdown.shutdown_all_ios_virtual_devices")

return M
