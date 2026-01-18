//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

/* NOTE: CHANGE THESE IF YOU WANT TO USE A DIFFERENT ICON THEME:*/
//@ pragma IconTheme RetroismIcons
//@ pragma Env QS_ICON_THEME=RetroismIcons

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "taskbar" as Taskbar
import "popups" as Popups

Scope {
    id: root
    FontLoader {
        id: iconFont
        source: "fonts/MaterialSymbolsSharp_Filled_36pt-Regular.ttf"
    }
    FontLoader {
        id: fontMonaco
        source: "fonts/Monaco.ttf"
    }
    FontLoader {
        id: fontCharcoal
        source: "fonts/Charcoal.ttf"
    }
    Taskbar.Bar {}

    // ============ SETTINGS WIDGET (Overlay) ============
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: settingsWindow
            required property var modelData
            screen: modelData
            visible: Config.openSettingsWindow && Hyprland.focusedMonitor.name === modelData.name
            
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            
            property int currentTab: 0

            Rectangle {
                width: 420
                height: 380
                x: (settingsWindow.width - width) / 2
                y: (settingsWindow.height - height) / 2
                color: Config.colors.base

                Popups.PopupWindowFrame {
                    id: settingsWindowFrame
                    anchors.fill: parent
                    windowTitle: "Settings"
                    windowTitleIcon: "\ue8b8"
                    windowTitleDecorationWidth: 100
                    showCloseButton: true
                    onCloseClicked: Config.openSettingsWindow = false

                    Item {
                        anchors.fill: parent
                        anchors.margins: 12
                        anchors.topMargin: 32
                        clip: true

                        // Tab Bar
                        Row {
                            id: tabBar
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            spacing: 2

                            Repeater {
                                model: ["Appearance", "System", "About"]
                                Rectangle {
                                    width: (parent.width - 4) / 3
                                    height: 28
                                    color: settingsWindow.currentTab === index ? Config.colors.highlight : Config.colors.shadow
                                    border.width: 1
                                    border.color: Config.colors.outline

                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.margins: 1
                                        anchors.bottomMargin: settingsWindow.currentTab === index ? 0 : 1
                                        color: "transparent"
                                        border.width: 1
                                        border.color: settingsWindow.currentTab === index ? Config.colors.highlight : Config.colors.base
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        font.family: fontCharcoal.name
                                        font.pixelSize: 11
                                        color: Config.colors.text
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: settingsWindow.currentTab = index
                                    }
                                }
                            }
                        }

                        // Tab Content
                        Rectangle {
                            anchors.top: tabBar.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.topMargin: -1
                            color: Config.colors.highlight
                            border.width: 1
                            border.color: Config.colors.outline

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 8
                                color: Config.colors.base
                                border.width: 1
                                border.color: Config.colors.shadow

                                // === APPEARANCE TAB ===
                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    visible: settingsWindow.currentTab === 0

                                    Column {
                                        anchors.fill: parent
                                        spacing: 14

                                        // Font Size
                                        Column {
                                            width: parent.width
                                            spacing: 4
                                            Text { text: "Font Size"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                            Row {
                                                spacing: 10
                                                Rectangle {
                                                    width: 180; height: 20
                                                    color: Config.colors.shadow
                                                    border.width: 1; border.color: Config.colors.outline
                                                    Rectangle {
                                                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.margins: 2
                                                        width: (Config.settings.bar.fontSize - 8) / 12 * (parent.width - 4)
                                                        color: Config.colors.accent
                                                    }
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: function(mouse) {
                                                            Config.settings.bar.fontSize = Math.max(8, Math.min(20, Math.round(8 + (mouse.x / width) * 12)));
                                                        }
                                                    }
                                                }
                                                Text { text: Config.settings.bar.fontSize + "px"; font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                            }
                                        }

                                        // Tray Icon Size
                                        Column {
                                            width: parent.width
                                            spacing: 4
                                            Text { text: "Tray Icon Size"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                            Row {
                                                spacing: 10
                                                Rectangle {
                                                    width: 180; height: 20
                                                    color: Config.colors.shadow
                                                    border.width: 1; border.color: Config.colors.outline
                                                    Rectangle {
                                                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.margins: 2
                                                        width: (Config.settings.bar.trayIconSize - 12) / 12 * (parent.width - 4)
                                                        color: Config.colors.accent
                                                    }
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: function(mouse) {
                                                            Config.settings.bar.trayIconSize = Math.max(12, Math.min(24, Math.round(12 + (mouse.x / width) * 12)));
                                                        }
                                                    }
                                                }
                                                Text { text: Config.settings.bar.trayIconSize + "px"; font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                            }
                                        }

                                        // Checkboxes
                                        Row {
                                            spacing: 8
                                            Rectangle {
                                                width: 16; height: 16
                                                color: Config.colors.shadow; border.width: 1; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: Config.settings.bar.monochromeTrayIcons ? "✓" : ""; font.pixelSize: 12; font.bold: true; color: Config.colors.text }
                                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.settings.bar.monochromeTrayIcons = !Config.settings.bar.monochromeTrayIcons }
                                            }
                                            Text { text: "Monochrome Tray Icons"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                        }

                                        Row {
                                            spacing: 8
                                            Rectangle {
                                                width: 16; height: 16
                                                color: Config.colors.shadow; border.width: 1; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: Config.settings.militaryTimeClockFormat ? "✓" : ""; font.pixelSize: 12; font.bold: true; color: Config.colors.text }
                                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.settings.militaryTimeClockFormat = !Config.settings.militaryTimeClockFormat }
                                            }
                                            Text { text: "24-Hour Clock Format"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                        }

                                        // Theme Selector
                                        Column {
                                            width: parent.width
                                            spacing: 6
                                            Text { text: "Theme"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                            Flow {
                                                width: parent.width
                                                spacing: 6
                                                Repeater {
                                                    model: Object.keys(Config.themes)
                                                    Rectangle {
                                                        property string themeName: modelData
                                                        width: 70; height: 50
                                                        color: Config.settings.currentTheme === themeName ? Config.colors.highlight : Config.colors.shadow
                                                        border.width: Config.settings.currentTheme === themeName ? 2 : 1
                                                        border.color: Config.settings.currentTheme === themeName ? Config.themes[themeName].accent : Config.colors.outline
                                                        Column {
                                                            anchors.centerIn: parent
                                                            spacing: 3
                                                            Row {
                                                                anchors.horizontalCenter: parent.horizontalCenter
                                                                spacing: 2
                                                                Rectangle { width: 10; height: 10; color: Config.themes[themeName].base; border.width: 1; border.color: Config.themes[themeName].outline }
                                                                Rectangle { width: 10; height: 10; color: Config.themes[themeName].accent; border.width: 1; border.color: Config.themes[themeName].outline }
                                                                Rectangle { width: 10; height: 10; color: Config.themes[themeName].shadow; border.width: 1; border.color: Config.themes[themeName].outline }
                                                            }
                                                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: themeName; font.family: fontMonaco.name; font.pixelSize: 8; color: Config.colors.text }
                                                        }
                                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.settings.currentTheme = themeName }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                // === SYSTEM TAB ===
                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    visible: settingsWindow.currentTab === 1

                                    Column {
                                        anchors.fill: parent
                                        spacing: 14

                                        // Terminal
                                        Column {
                                            width: parent.width
                                            spacing: 4
                                            Text { text: "Terminal Application"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                            Row {
                                                spacing: 6
                                                Rectangle {
                                                    width: 180; height: 24
                                                    color: Config.colors.shadow; border.width: 1; border.color: Config.colors.outline
                                                    TextInput {
                                                        id: terminalInput
                                                        anchors.fill: parent; anchors.margins: 4
                                                        text: Config.hyprlandTerminal
                                                        font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text
                                                        clip: true; selectByMouse: true; activeFocusOnPress: true
                                                    }
                                                }
                                                Rectangle {
                                                    width: 45; height: 24
                                                    color: termSaveArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                    border.width: 1; border.color: Config.colors.outline
                                                    Text { anchors.centerIn: parent; text: "Save"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                                    MouseArea { id: termSaveArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.setHyprlandTerminal(terminalInput.text) }
                                                }
                                            }
                                            Text { text: "→ hyprland.conf: $terminal"; font.family: fontMonaco.name; font.pixelSize: 8; color: Config.colors.text; opacity: 0.5 }
                                        }

                                        // File Manager
                                        Column {
                                            width: parent.width
                                            spacing: 4
                                            Text { text: "File Manager Application"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                            Row {
                                                spacing: 6
                                                Rectangle {
                                                    width: 180; height: 24
                                                    color: Config.colors.shadow; border.width: 1; border.color: Config.colors.outline
                                                    TextInput {
                                                        id: filesInput
                                                        anchors.fill: parent; anchors.margins: 4
                                                        text: Config.hyprlandFileManager
                                                        font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text
                                                        clip: true; selectByMouse: true; activeFocusOnPress: true
                                                    }
                                                }
                                                Rectangle {
                                                    width: 45; height: 24
                                                    color: filesSaveArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                    border.width: 1; border.color: Config.colors.outline
                                                    Text { anchors.centerIn: parent; text: "Save"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                                    MouseArea { id: filesSaveArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.setHyprlandFileManager(filesInput.text) }
                                                }
                                            }
                                            Text { text: "→ hyprland.conf: $fileManager"; font.family: fontMonaco.name; font.pixelSize: 8; color: Config.colors.text; opacity: 0.5 }
                                        }

                                        Rectangle { width: parent.width; height: 1; color: Config.colors.outline; opacity: 0.5 }

                                        Text { text: "System Information"; font.family: fontCharcoal.name; font.pixelSize: 11; font.bold: true; color: Config.colors.text }

                                        Grid {
                                            columns: 2; columnSpacing: 10; rowSpacing: 6
                                            Text { text: "OS:"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.osName; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: "Version:"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.osVersion; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: "CPU:"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.cpu; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: "GPU:"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.gpu; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: "RAM:"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.ram; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text }
                                        }
                                    }
                                }

                                // === ABOUT TAB ===
                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    visible: settingsWindow.currentTab === 2

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 12
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Linux Retroism"; font.family: fontCharcoal.name; font.pixelSize: 20; color: Config.colors.text }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Version " + Config.settings.version; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text }
                                        Rectangle { width: 200; height: 1; color: Config.colors.outline; anchors.horizontalCenter: parent.horizontalCenter }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "A 1980-1990's retro UI aesthetic\nfor Hyprland & Sway"; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text; horizontalAlignment: Text.AlignHCenter }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Created by diinki"; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.accent }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "github.com/diinki/linux-retroism"; font.family: fontMonaco.name; font.pixelSize: 9; color: Config.colors.text; opacity: 0.6 }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ============ POWER MENU WIDGET (Overlay) ============
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: powerMenu
            required property var modelData
            screen: modelData
            visible: Config.openPowerMenu && Hyprland.focusedMonitor.name === modelData.name
            
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"

            property string powerMenuState: ""
            
            function updateHyprlockTheme() {
                var c = Config.colors;
                var cmd = "sed -i " +
                    "-e 's/outer_color = rgb([^)]*)/outer_color = rgb(" + c.outline.slice(1) + ")/g' " +
                    "-e 's/inner_color = rgb([^)]*)/inner_color = rgb(" + c.base.slice(1) + ")/g' " +
                    "-e 's/font_color = rgb([^)]*)/font_color = rgb(" + c.text.slice(1) + ")/g' " +
                    "-e 's/check_color = rgb([^)]*)/check_color = rgb(" + c.accent.slice(1) + ")/g' " +
                    "-e 's/fail_color = rgb([^)]*)/fail_color = rgb(" + c.urgent.slice(1) + ")/g' " +
                    "-e 's/color = rgb(3e3d38)/color = rgb(" + c.text.slice(1) + ")/g' " +
                    "-e 's/color = rgb(626335)/color = rgb(" + c.accent.slice(1) + ")/g' " +
                    "/home/ozhan/.config/hypr/hyprlock.conf";
                Quickshell.execDetached(cmd);
            }
            
            property var powerActions: {
                "lock": { title: "Lock", icon: "\ue897", cmd: "hyprlock" },
                "sleep": { title: "Sleep", icon: "\ue91e", cmd: "systemctl suspend" },
                "logout": { title: "Logout", icon: "\ue9ba", cmd: "hyprctl dispatch exit" },
                "restart": { title: "Restart", icon: "\ue5d5", cmd: "systemctl reboot" },
                "shutdown": { title: "Shut Down", icon: "\ue8ac", cmd: "systemctl poweroff" }
            }

            onVisibleChanged: {
                if (!visible) powerMenuState = "";
            }

            Rectangle {
                width: 320
                height: 180
                x: (powerMenu.width - width) / 2
                y: (powerMenu.height - height) / 2
                color: Config.colors.base

                Popups.PopupWindowFrame {
                    anchors.fill: parent
                    windowTitle: powerMenu.powerMenuState === "" ? "Power" : "Confirm"
                    windowTitleIcon: "\uf418"
                    windowTitleDecorationWidth: 60
                    showCloseButton: true
                    onCloseClicked: { powerMenu.powerMenuState = ""; Config.openPowerMenu = false; }

                    Item {
                        anchors.fill: parent
                        anchors.margins: 12
                        anchors.topMargin: 32

                        // Main Menu
                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            visible: powerMenu.powerMenuState === ""

                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: "What would you like to do?"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }

                            Grid {
                                anchors.horizontalCenter: parent.horizontalCenter
                                columns: 5
                                spacing: 5

                                Repeater {
                                    model: ["lock", "sleep", "logout", "restart", "shutdown"]
                                    Rectangle {
                                        property string actionKey: modelData
                                        width: 50; height: 46
                                        property bool isShutdown: actionKey === "shutdown"
                                        color: btnArea.pressed ? Config.colors.shadow : (isShutdown ? Config.colors.urgent : Config.colors.highlight)
                                        border.width: 1; border.color: Config.colors.outline

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 2
                                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: powerMenu.powerActions[actionKey].icon; font.family: iconFont.name; font.pixelSize: 18; color: Config.colors.text }
                                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: powerMenu.powerActions[actionKey].title; font.family: fontMonaco.name; font.pixelSize: 7; color: Config.colors.text }
                                        }
                                        MouseArea { 
                                            id: btnArea
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (actionKey === "lock") {
                                                    powerMenu.updateHyprlockTheme();
                                                }
                                                Quickshell.execDetached(powerMenu.powerActions[actionKey].cmd);
                                                Config.openPowerMenu = false;
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 60; height: 22
                                color: cancelArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                border.width: 1; border.color: Config.colors.outline
                                Text { anchors.centerIn: parent; text: "Cancel"; font.family: fontCharcoal.name; font.pixelSize: 9; color: Config.colors.text }
                                MouseArea { id: cancelArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.openPowerMenu = false }
                            }
                        }

                        // Confirmation Screen
                        Column {
                            anchors.centerIn: parent
                            spacing: 12
                            visible: powerMenu.powerMenuState !== ""

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: powerMenu.powerMenuState !== "" ? "Are you sure you want to\n" + powerMenu.powerActions[powerMenu.powerMenuState].title + "?" : ""
                                font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                Rectangle {
                                    width: 70; height: 24
                                    color: yesArea.pressed ? Config.colors.shadow : Config.colors.urgent
                                    border.width: 1; border.color: Config.colors.outline
                                    Text { anchors.centerIn: parent; text: "Yes"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                    MouseArea {
                                        id: yesArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (powerMenu.powerMenuState !== "") Quickshell.execDetached(powerMenu.powerActions[powerMenu.powerMenuState].cmd);
                                            powerMenu.powerMenuState = ""; Config.openPowerMenu = false;
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 70; height: 24
                                    color: noArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                    border.width: 1; border.color: Config.colors.outline
                                    Text { anchors.centerIn: parent; text: "No"; font.family: fontCharcoal.name; font.pixelSize: 10; color: Config.colors.text }
                                    MouseArea { id: noArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: powerMenu.powerMenuState = "" }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
