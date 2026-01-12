<div align="center">

# <img src="https://media3.giphy.com/media/l4FGr7tMjH3ajuwy4/giphy.gif" width="4%"> Linux Retroism <img src="https://media3.giphy.com/media/l4FGr7tMjH3ajuwy4/giphy.gif" width="4%">

</div>

<div align="center">

<a href="https://discord.gg/gleep">![badge](https://img.shields.io/badge/discord-262622?style=for-the-badge&logo=discord&logoColor=262622&logoSize=auto&color=e2e2d3) </a>
<a href="https://ko-fi.com/diinki">![badge](https://img.shields.io/badge/tip-262622?style=for-the-badge&logo=kofi&logoColor=262622&logoSize=auto&color=e2e2d3) </a>
<a href="https://youtube.com/@diinkikot">![badge](https://img.shields.io/badge/youtube_video-262622?style=for-the-badge&logo=youtube&logoColor=262622&logoSize=auto&color=e2e2d3) </a>

</div>

<div align="center">

▐ **Linux Retroism is a Linux-rice based on the 1980-1990's user-interface aesthetic** ▌

</div>

![image](./screenshots/default.png)

| wallpaper by 96YOTTEA              | wallpaper: Metropolis             |
| ---------------------------------- | --------------------------------- |
| ![image](./screenshots/cherry.png) | ![image](./screenshots/yorha.png) |
|                                    |                                   |

<br>

### Features (v0.1) 🛈

- Automatic installer (`install.sh` script) with backup support
- Fully quickshell-based front-end (taskbar, app launcher, settings menu, etc)
- Theme support & Built-in theme switcher
- Icon theme & GTK theme

<br>

### Dependencies ✓

You can use either Hyprland or SwayFX/Sway, although I actively use & debug on hyprland. The install script
will let you know if any dependencies are missing.

In general, you must install these or else things may break & not work.

<div style="border-left: 4px solid #c8bfa1ff; padding: 12px 100px 1px 12px; background-color: #0000003e; margin-bottom: 8px">
<strong>Window Manager:</strong><br>

`Hyprland` or `SwayFX` | `hyprpaper` or `swaybg`

</div>

<div style="border-left: 4px solid #c8bfa1ff; padding: 12px 100px 1px 12px; background-color: #0000003e; margin-bottom: 8px">
<strong>Applications:</strong><br>

`nemo`, `kitty`, `nwg-look`, `quickshell`

</div>

<div style="border-left: 4px solid #c8bfa1ff; padding: 12px 4px 1px 12px; background-color: #0000003e; margin-bottom: 8px">
<strong>Utilities:</strong><br>

`grim`, `slurp`, `swappy`, `hyprshot`, `wl-clipboard`, `mako`, `dconf`, `jq`, `socat`,

</div>

<br>

### Download & Installation 🡇

<div style="border-left: 4px solid #c8bfa1ff; padding: 12px 4px 1px 2px; background-color: #0000003e; margin-bottom: 12px">

- After you've installed or cloned the repo, simply run the included `install.sh` script.
- Note that you must still manually move the GTK theme and Icon
  theme to `~/.local/share/icons` and `~/.local/share/themes`
  respectively. You can set them to be active with the nwg-look
  GUI.
- To update, simply get a newer version, and run the `install.sh` script once more.
- You can also manually move the config directories if you wish to manually install.
</div>

I recommend getting versions from the `releases` page, but you can also git clone the repo if you
want the latest changes at a higher risk.

The script will take care of everything and will create a backups of all
existing config files that it would replace.

<br>

### ✦ Notes & TODO Lists

I recommend using Hyprland, as there are some issues sway has with NVIDIA GPUs in my experience.
I will attempt to add fixes to sway if any bugs occur.

Both the Icon theme and GTK theme are very early, I will continue to edit and improve them in
future versions.

**v0.2 TODO List:**

- [ ] Update GTK Theme to be less janky.
- [ ] Higher res icon theme and more icons.
- [ ] Proper settings menu, change font sizes, font, wallpapers, etc.
- [ ] Refactor quickshell code where need be.
- [ ] Better laptop support (battery indicator)
- [ ] UI/UX Improvements

### ✦ License

This project is licensed under the permissive MIT license, which is included in the root directory
of this repository.
