---@class Executables
---@field xcrun string?
---@field emulator string?
---@field adb string?
---@field setup function(): nil
local M = {}

local function get_xcrun_path()
	local paths = {
		-- "xcrun",
		"/usr/bin/xcrun",
	}

	for _, path in ipairs(paths) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end
end

local function get_emulator_path()
	local paths = {
		"emulator",
		function()
			local android_sdk_path = vim.env["ANDROID_HOME"]

			if android_sdk_path == nil then
				return nil
			end

			return android_sdk_path .. "/emulator/emulator"
		end,
	}

	for _, path in ipairs(paths) do
		local executable_path = type(path) == "function" and path() or path
		if vim.fn.executable(executable_path) == 1 then
			return executable_path
		end
	end
end

local function get_adb_path()
	local paths = {
		"adb",
		function()
			local android_sdk_path = vim.env["ANDROID_HOME"]

			if android_sdk_path == nil then
				return nil
			end

			return android_sdk_path .. "/platform-tools/adb"
		end,
	}

	for _, path in ipairs(paths) do
		local executable_path = type(path) == "function" and path() or path
		if vim.fn.executable(executable_path) == 1 then
			return executable_path
		end
	end
end

M.setup = function()
	M.xcrun = get_xcrun_path()
	M.emulator = get_emulator_path()
	M.adb = get_adb_path()
end

return M
