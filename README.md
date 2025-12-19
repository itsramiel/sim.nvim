# 📱 sim.nvim
A neovim plugin to interact with iOS and Android virtual devices and soon physical devices.

❗Macos only

## Features

### 🤖 Android Virtual Devices
- Boot with options of: cold boot, no audio
- Shutdown individual or all virtual devices
- Copy name and adb id
- Paste machine clipboard to virtual device

###  iOS Virtual Devices
- Boot
- Shutdown individual or all virtual devices
- Copy name and udid

## 📦 Installation
Install the plugin with your package manager.

### Dependencies:
- [coop.nvim](https://github.com/gregorias/coop.nvim). This used to perform operations asynchronously ⚡ and not freeze neovim

Example with lazy.nvim:
```lua
return {
	"itsramiel/sim.nvim",
	dependencies = {
		"gregorias/coop.nvim",
	},
}
```

## Usage
The plugin exposes low level functions to implement your custom commands with as well as ready made function to be consumed.

### Convenience Methods for direct usage
You can map the following functions to a keymapping
```lua
local sim_ui = require("sim.ui")
-- Prompts ios device to launch. If there is only one, it launches it directly
sim_ui.boot.boot_ios_virtual_device()

-- Prompts ios device to shutdown. If there is only one, it shuts it down directly
sim_ui.shutdown.shutdown_ios_virtual_device()

-- Prompts android device to launch. If there is only one, it launches it directly
sim_ui.boot.boot_android_virtual_device()

-- Prompts android virtual device to shutdown. If there is only one, it shuts it down directly
sim_ui.shutdown.shutdown_android_virtual_device()

-- Shuts down all virtual devices(iOS & Android)
sim_ui.shutdown.shutdown_all_virtual_devices()

-- List Android Virtual Devices to perform an action on
sim_ui.list_devices.list_android_virtual_devices()

-- List iOS Virtual Devices to perform an action on
sim_ui.list_devices.list_ios_virtual_devices()

-- List Android Physical Devices to perform an action on
sim_ui.list_devices.list_android_physical_devices()

-- List iOS Physical Devices to perform an action on
sim_ui.list_devices.list_ios_physical_devices()

-- Prompts to select among physical/virtual android/ios devices to list and perform an action on
sim_ui.list_devices.list_all()
```

### Lower level api for custom implementations.(The convenience methods use these internally)
The lower level api can be found under `sim.api`

## Example of complete setup
```lua
return {
  "itsramiel/sim.nvim",
  dependencies = {
    "gregorias/coop.nvim",
  },
  config = function()
    local sim_ui = require("sim.ui")

    local keymap = vim.keymap

    local opts = {
      noremap = true,
      silent = true,
      desc = "Prompts ios device to launch. If there is only one, it launches it directly",
    }
    keymap.set("n", "<leader>sbi", sim_ui.boot.boot_ios_virtual_device, opts)

    opts.desc = "Prompts ios device to shutdown. If there is only one, it shuts it down directly"
    keymap.set("n", "<leader>ssi", sim_ui.shutdown.shutdown_ios_virtual_device, opts)

    opts.desc = "Prompts android device to launch. If there is only one, it launches it directly"
    keymap.set("n", "<leader>sba", sim_ui.boot.boot_android_virtual_device, opts)

    opts.desc = "Prompts android virtual device to shutdown. If there is only one, it shuts it down directly"
    keymap.set("n", "<leader>ssa", sim_ui.shutdown.shutdown_android_virtual_device, opts)

    opts.desc = "Shuts down all virtual devices(iOS & Android)"
    keymap.set("n", "<leader>ssx", sim_ui.shutdown.shutdown_all_virtual_devices, opts)

    opts.desc = "List devices to perform an action on"
    keymap.set("n", "<leader>sl", sim_ui.list_devices.list_all, opts)
  end,
}
```

## Requirements
The plugin utilizes xcode and android studio command line tools to interact with the virtual devices. Make sure to have them setup.

### iOS
- xcrun

### Android
- emulator
- adb

## Acknowledgement
This plugin is inspired by the macos menu bar app [Minisim](https://github.com/okwasniewski/MiniSim)
