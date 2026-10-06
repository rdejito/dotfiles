# Linux Dotfiles

My personal Linux desktop configuration, focused on a clean, customizable, and reproducible workflow.

The repository is designed to support **multiple window managers** without mixing their configurations together. WM-specific configurations live under `wm/`, while shared applications and utilities live under `apps/`.

> **Current WM:** i3
> **Current shared tools:** Polybar, Rofi, Picom, Ghostty
> **Shell:** Zsh

---

## Repository Structure

```text
dotfiles/
├── apps/
│   ├── ghostty/
│   │   └── config
│   │
│   ├── picom/
│   │   └── picom.conf
│   │
│   ├── polybar/
│   │   ├── config.ini
│   │   ├── launch.sh
│   │   └── scripts/
│   │       ├── i3-apps.sh
│   │       ├── network.sh
│   │       ├── storage.sh
│   │       └── updates.sh
│   │
│   └── rofi/
│       ├── anime.rasi
│       ├── config.rasi
│       └── cyberpunk-red.rasi
│
├── wm/
│   └── i3/
│       └── config
│
├── install.sh
└── README.md
```

### Directory overview

| Directory               | Purpose                                |
| ----------------------- | -------------------------------------- |
| `wm/`                   | Window-manager-specific configurations |
| `apps/`                 | Shared application configurations      |
| `apps/polybar/scripts/` | Custom Polybar modules/scripts         |
| `install.sh`            | Installation and symlink management    |
| `README.md`             | Documentation                          |

---

## Features

* i3 window manager configuration
* Cyberpunk-inspired red theme
* Polybar with:

  * Workspace information
  * Date/time
  * CPU usage
  * Memory usage
  * Network status
  * Storage information
  * Package update count
  * Currently running applications
  * Volume status
* Rofi launcher and custom themes
* Picom configuration
* Ghostty terminal configuration
* Custom shell scripts
* Symlink-based configuration management
* Designed for multiple window managers

---

## Installation

### Requirements

This repository assumes a Linux environment with:

* Git
* Bash
* `~/.config` support
* The applications required by the configuration you want to use

The configuration is primarily developed and tested on **Linux Mint**.

---

### Clone the repository

Using SSH:

```bash
git clone git@github.com:rdejito/dotfiles.git ~/dotfiles
```

Or using HTTPS:

```bash
git clone https://github.com/rdejito/dotfiles.git ~/dotfiles
```

Enter the repository:

```bash
cd ~/dotfiles
```

Make the installer executable:

```bash
chmod +x install.sh
```

---

## Installing a Window Manager Profile

The installer accepts the desired window manager as an argument.

For i3:

```bash
./install.sh i3
```

The installer will create symlinks such as:

```text
~/.config/i3/config
        ↓
~/dotfiles/wm/i3/config

~/.config/polybar
        ↓
~/dotfiles/apps/polybar

~/.config/rofi
        ↓
~/dotfiles/apps/rofi
```

This means the configuration remains inside the Git repository while applications continue to use their normal paths under `~/.config`.

---

## Backups

The installer does not blindly overwrite existing configurations.

If a configuration already exists, it is moved to a `.backup` file or directory before the symlink is created.

For example:

```text
~/.config/polybar
~/.config/polybar.backup
```

If a backup with that name already exists, a timestamped backup is created instead.

This makes the installation reversible and reduces the risk of losing an existing configuration.

---

## Adding Another Window Manager

The repository is structured so additional WMs can be added without reorganizing the existing configuration.

For example:

```text
wm/
├── i3/
│   └── config
├── dwm/
│   └── config.h
├── hyprland/
│   └── hyprland.conf
└── awesome/
    └── rc.lua
```

The installer can then be extended with another profile:

```bash
./install.sh hyprland
```

WM-specific configurations should remain inside `wm/<window-manager>/`.

Shared applications should remain inside `apps/`.

---

## Updating the Dotfiles

Because the configurations are symlinked into the repository, changes made through `~/.config` are automatically tracked by Git.

For example:

```bash
vim ~/.config/i3/config
```

The actual file being edited is:

```text
~/dotfiles/wm/i3/config
```

After making changes:

```bash
cd ~/dotfiles

git status
git add .
git commit -m "Update i3 configuration"
git push
```

---

## Restoring on Another Machine

Clone the repository:

```bash
git clone git@github.com:rdejito/dotfiles.git ~/dotfiles
```

Then install the desired profile:

```bash
cd ~/dotfiles
./install.sh i3
```

Your configuration files will be linked back into `~/.config`.

---

## Notes

This repository contains my personal configuration and is primarily intended as a reference and starting point for other users.

Some configurations may depend on:

* Specific applications
* Fonts
* Icons
* Linux distributions
* X11/Wayland
* Monitor layouts
* Hardware-specific settings
* Personal scripts

You may need to modify the configurations to match your own system.

**Do not blindly copy configuration files without reviewing them first.**

---

## Roadmap

* [x] i3 configuration
* [x] Polybar configuration
* [x] Rofi configuration
* [x] Picom configuration
* [x] Ghostty configuration
* [x] Symlink-based installation
* [x] Backup existing configurations
* [ ] dwm configuration
* [ ] Hyprland configuration
* [ ] AwesomeWM configuration
* [ ] WM-specific installation profiles
* [ ] Automated dependency checking
* [ ] Improved installation/uninstallation commands

---

## License

Use, modify, and adapt these configurations for your own system.

If you find something useful here, feel free to take it and make it your own.
