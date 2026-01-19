pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Hyprland config values
    property string hyprlandTerminal: "kitty"
    property string hyprlandFileManager: "nautilus"
    property string hyprlandConfigPath: "/home/ozhan/.config/hypr/hyprland.conf"

    // Read hyprland.conf on startup
    property string terminalOutput: ""
    property string fileManagerOutput: ""

    Process {
        id: readTerminal
        command: ["grep", "^\\$terminal", hyprlandConfigPath]
        running: true
        stdout: SplitParser {
            onRead: data => { root.terminalOutput = data; }
        }
        onExited: {
            var match = root.terminalOutput.match(/\$terminal\s*=\s*(.+)/);
            if (match) hyprlandTerminal = match[1].trim();
        }
    }

    Process {
        id: readFileManager
        command: ["grep", "^\\$fileManager", hyprlandConfigPath]
        running: true
        stdout: SplitParser {
            onRead: data => { root.fileManagerOutput = data; }
        }
        onExited: {
            var match = root.fileManagerOutput.match(/\$fileManager\s*=\s*(.+)/);
            if (match) hyprlandFileManager = match[1].trim();
        }
    }

    // Functions to update hyprland.conf
    function setHyprlandTerminal(value) {
        hyprlandTerminal = value;
        updateTerminalProc.command = ["sed", "-i", "s/^\\$terminal = .*/$terminal = " + value + "/", hyprlandConfigPath];
        updateTerminalProc.running = true;
    }

    function setHyprlandFileManager(value) {
        hyprlandFileManager = value;
        updateFileManagerProc.command = ["sed", "-i", "s/^\\$fileManager = .*/$fileManager = " + value + "/", hyprlandConfigPath];
        updateFileManagerProc.running = true;
    }

    Process {
        id: updateTerminalProc
        onExited: console.log("Hyprland terminal updated")
    }

    Process {
        id: updateFileManagerProc
        onExited: console.log("Hyprland fileManager updated")
    }

    //*=======================================================================*/
    // READ THIS NOTE:
    // Simply add to this list in order to create your
    // own color schemes, they will automatically show up in the theme picker.
    property var colors: themes[themes[settings.currentTheme] == null ? 'default' : settings.currentTheme]
    property var themes: {
        "default": {
            "base": "#d8d8d8",
            "shadow": "#9b9b9b",
            "highlight": "#efefef",
            "urgent": "#ff723e",
            "accent": "#207874",
            "text": "#000000",
            "outline": "#000000",
            "outlineGradientFade": "#161616",
            "defaultWallpaperPath": ""
        },
        "yorha": {
            "base": "#d9caba",
            "shadow": "#baafa1",
            "highlight": "#f0e2d3",
            "urgent": "#ff854c",
            "accent": "#626335",
            "text": "#3e3d38",
            "outline": "#3d3d39",
            "outlineGradientFade": "#5b5b45",
            "defaultWallpaperPath": ""
        },
        "cherry": {
            "base": "#f4c9ef",
            "shadow": "#c7a4cc",
            "highlight": "#f9d0f7",
            "urgent": "#ff936c",
            "accent": "#c950bb",
            "text": "#321d32",
            "outline": "#20091d",
            "outlineGradientFade": "#3e233e",
            "defaultWallpaperPath": ""
        },
        "indigo": {
            "base": "#bac4e6",
            "shadow": "#7e8bad",
            "highlight": "#d0def9",
            "urgent": "#e83939",
            "accent": "#3e7c99",
            "text": "#0d0d19",
            "outline": "#1a2135",
            "outlineGradientFade": "#223143",
            "defaultWallpaperPath": ""
        },
        "gleep": {
            "base": "#bae6c5",
            "shadow": "#93c48c",
            "highlight": "#ccf9e7",
            "urgent": "#ff7559",
            "accent": "#3e9949",
            "text": "#0d1913",
            "outline": "#21351a",
            "outlineGradientFade": "#284223",
            "defaultWallpaperPath": ""
        }
    }

    enum SystemPopup {
        Startmenu,
        ThemePicker,
        AppLauncher,
        None
    }

    property bool openSettingsWindow: false
    property bool openPowerMenu: false
    property bool openNotificationHistory: false

    property alias settings: settingsJsonAdapter.settings
    FileView {
        path: Qt.resolvedUrl("./settings.json")
        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: reload()
        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: settingsJsonAdapter
            property JsonObject settings: JsonObject {
                property string version: "0.1"
                property bool militaryTimeClockFormat: true
                property string systemProfileImageSource: "/home/username/Pictures/system_profile_picture.png"
                property string currentTheme: "default"
                property bool setWallpaperToThemeWallpaper: true
                property JsonObject execCommands: JsonObject {
                    property string terminal: "kitty"
                    property string files: "nemo"
                }
                property JsonObject systemDetails: JsonObject {
                    property string osName: "Linux Distro"
                    property string osVersion: "Distro Version"
                    property string ram: "Ram"
                    property string cpu: "CPU Name"
                    property string gpu: "GPU Name"
                }
                property JsonObject bar: JsonObject {
                    property int fontSize: 12
                    property int trayIconSize: 16
                    property bool monochromeTrayIcons: true
                }

                onCurrentThemeChanged: {
                    console.info("Updated theme to: " + currentTheme);
                }
            }
        }
    }
}
