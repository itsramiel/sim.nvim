local M = {}

M.boot_device = require("sim.api.boot.boot_device")
M.boot_ios_virtual_device = require("sim.api.boot.boot_ios_virtual_device")
M.boot_android_virtual_device = require("sim.api.boot.boot_android_virtual_device")

return M
