//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

/* NOTE: CHANGE THESE IF YOU WANT TO USE A DIFFERENT ICON THEME:*/
//@ pragma IconTheme RetroismIcons
//@ pragma Env QS_ICON_THEME=RetroismIcons

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications

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

    // ============ NOTIFICATION HISTORY IPC ============
    IpcHandler {
        target: "notificationHistory"
        function toggleNotificationHistory() {
            Config.openNotificationHistory = !Config.openNotificationHistory;
        }
    }

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
                width: 700
                height: 560
                x: (settingsWindow.width - width) / 2
                y: (settingsWindow.height - height) / 2
                color: Config.colors.base

                Popups.PopupWindowFrame {
                    id: settingsWindowFrame
                    anchors.fill: parent
                    windowTitle: "Settings"
                    windowTitleIcon: "\ue8b8"
                    windowTitleDecorationWidth: 120
                    showCloseButton: true
                    onCloseClicked: Config.openSettingsWindow = false

                    Item {
                        anchors.fill: parent
                        anchors.margins: 16
                        anchors.topMargin: 40
                        clip: true

                        // Tab Bar
                        Row {
                            id: tabBar
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            spacing: 3

                            Repeater {
                                model: ["Appearance", "System", "Network", "Bluetooth", "About"]
                                Rectangle {
                                    width: (parent.width - 12) / 5
                                    height: 36
                                    color: settingsWindow.currentTab === index ? Config.colors.highlight : Config.colors.shadow
                                    border.width: 2
                                    border.color: Config.colors.outline

                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        anchors.bottomMargin: settingsWindow.currentTab === index ? 0 : 2
                                        color: "transparent"
                                        border.width: 1
                                        border.color: settingsWindow.currentTab === index ? Config.colors.highlight : Config.colors.base
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        font.family: fontCharcoal.name
                                        font.pixelSize: 14
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
                                anchors.margins: 12
                                color: Config.colors.base
                                border.width: 2
                                border.color: Config.colors.shadow

                                // === APPEARANCE TAB ===
                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    visible: settingsWindow.currentTab === 0

                                    Column {
                                        anchors.fill: parent
                                        spacing: 20

                                        // Font Size
                                        Column {
                                            width: parent.width
                                            spacing: 8
                                            Text { text: "Font Size"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text }
                                            Row {
                                                spacing: 16
                                                Rectangle {
                                                    width: 280; height: 28
                                                    color: Config.colors.shadow
                                                    border.width: 2; border.color: Config.colors.outline
                                                    Rectangle {
                                                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.margins: 3
                                                        width: (Config.settings.bar.fontSize - 8) / 12 * (parent.width - 6)
                                                        color: Config.colors.accent
                                                    }
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: function(mouse) {
                                                            Config.settings.bar.fontSize = Math.max(8, Math.min(20, Math.round(8 + (mouse.x / width) * 12)));
                                                        }
                                                    }
                                                }
                                                Text { text: Config.settings.bar.fontSize + "px"; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                            }
                                        }

                                        // Tray Icon Size
                                        Column {
                                            width: parent.width
                                            spacing: 8
                                            Text { text: "Tray Icon Size"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text }
                                            Row {
                                                spacing: 16
                                                Rectangle {
                                                    width: 280; height: 28
                                                    color: Config.colors.shadow
                                                    border.width: 2; border.color: Config.colors.outline
                                                    Rectangle {
                                                        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.margins: 3
                                                        width: (Config.settings.bar.trayIconSize - 12) / 12 * (parent.width - 6)
                                                        color: Config.colors.accent
                                                    }
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: function(mouse) {
                                                            Config.settings.bar.trayIconSize = Math.max(12, Math.min(24, Math.round(12 + (mouse.x / width) * 12)));
                                                        }
                                                    }
                                                }
                                                Text { text: Config.settings.bar.trayIconSize + "px"; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                            }
                                        }

                                        // Checkboxes
                                        Row {
                                            spacing: 12
                                            Rectangle {
                                                width: 24; height: 24
                                                color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: Config.settings.bar.monochromeTrayIcons ? "✓" : ""; font.pixelSize: 18; font.bold: true; color: Config.colors.text }
                                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.settings.bar.monochromeTrayIcons = !Config.settings.bar.monochromeTrayIcons }
                                            }
                                            Text { text: "Monochrome Tray Icons"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                        }

                                        Row {
                                            spacing: 12
                                            Rectangle {
                                                width: 24; height: 24
                                                color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: Config.settings.militaryTimeClockFormat ? "✓" : ""; font.pixelSize: 18; font.bold: true; color: Config.colors.text }
                                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.settings.militaryTimeClockFormat = !Config.settings.militaryTimeClockFormat }
                                            }
                                            Text { text: "24-Hour Clock Format"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                        }

                                        // Theme Selector
                                        Column {
                                            width: parent.width
                                            spacing: 10
                                            Text { text: "Theme"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text }
                                            Flow {
                                                width: parent.width
                                                spacing: 10
                                                Repeater {
                                                    model: Object.keys(Config.themes)
                                                    Rectangle {
                                                        property string themeName: modelData
                                                        width: 100; height: 70
                                                        color: Config.settings.currentTheme === themeName ? Config.colors.highlight : Config.colors.shadow
                                                        border.width: Config.settings.currentTheme === themeName ? 3 : 2
                                                        border.color: Config.settings.currentTheme === themeName ? Config.themes[themeName].accent : Config.colors.outline
                                                        Column {
                                                            anchors.centerIn: parent
                                                            spacing: 6
                                                            Row {
                                                                anchors.horizontalCenter: parent.horizontalCenter
                                                                spacing: 4
                                                                Rectangle { width: 16; height: 16; color: Config.themes[themeName].base; border.width: 2; border.color: Config.themes[themeName].outline }
                                                                Rectangle { width: 16; height: 16; color: Config.themes[themeName].accent; border.width: 2; border.color: Config.themes[themeName].outline }
                                                                Rectangle { width: 16; height: 16; color: Config.themes[themeName].shadow; border.width: 2; border.color: Config.themes[themeName].outline }
                                                            }
                                                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: themeName; font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text }
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
                                    id: systemTab
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    visible: settingsWindow.currentTab === 1

                                    property int brightness: 0
                                    property int maxBrightness: 1
                                    property real volume: 1.0
                                    property bool muted: false
                                    property string brightnessOutput: ""
                                    property string maxBrightnessOutput: ""
                                    property string volumeOutput: ""

                                    Component.onCompleted: {
                                        maxBrightnessProc.running = true;
                                        volumeProc.running = true;
                                    }

                                    Process {
                                        id: brightnessProc
                                        command: ["brightnessctl", "g"]
                                        stdout: SplitParser { onRead: data => { systemTab.brightnessOutput = data.trim(); } }
                                        onExited: { systemTab.brightness = parseInt(systemTab.brightnessOutput) || 0; }
                                    }

                                    Process {
                                        id: maxBrightnessProc
                                        command: ["brightnessctl", "m"]
                                        stdout: SplitParser { onRead: data => { systemTab.maxBrightnessOutput = data.trim(); } }
                                        onExited: { 
                                            systemTab.maxBrightness = parseInt(systemTab.maxBrightnessOutput) || 1; 
                                            brightnessProc.running = true;
                                        }
                                    }

                                    Process {
                                        id: setBrightnessProc
                                    }

                                    Process {
                                        id: volumeProc
                                        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                                        stdout: SplitParser { onRead: data => { systemTab.volumeOutput = data.trim(); } }
                                        onExited: {
                                            var match = systemTab.volumeOutput.match(/Volume:\s*([\d.]+)/);
                                            if (match) systemTab.volume = parseFloat(match[1]);
                                            systemTab.muted = systemTab.volumeOutput.includes("[MUTED]");
                                        }
                                    }

                                    Process {
                                        id: setVolumeProc
                                        onExited: { volumeProc.running = true; }
                                    }

                                    function setBrightness(percent) {
                                        setBrightnessProc.command = ["brightnessctl", "s", percent + "%"];
                                        setBrightnessProc.running = true;
                                        brightness = Math.round(maxBrightness * percent / 100);
                                    }

                                    function setVolume(percent) {
                                        setVolumeProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (percent / 100).toFixed(2)];
                                        setVolumeProc.running = true;
                                    }

                                    function toggleMute() {
                                        setVolumeProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
                                        setVolumeProc.running = true;
                                    }

                                    Flickable {
                                        anchors.fill: parent
                                        contentHeight: systemContent.height
                                        clip: true

                                        Column {
                                            id: systemContent
                                            width: parent.width
                                            spacing: 16

                                            // Brightness
                                            Column {
                                                width: parent.width
                                                spacing: 8
                                                Row {
                                                    spacing: 10
                                                    Text { text: "\ue518"; font.family: iconFont.name; font.pixelSize: 20; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                                    Text { text: "Brightness"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                                }
                                                Row {
                                                    spacing: 16
                                                    Rectangle {
                                                        width: 400; height: 28
                                                        color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                        Rectangle {
                                                            anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.margins: 3
                                                            width: (systemTab.maxBrightness > 0 ? systemTab.brightness / systemTab.maxBrightness : 0) * (parent.width - 6)
                                                            color: Config.colors.accent
                                                        }
                                                        MouseArea {
                                                            anchors.fill: parent
                                                            onClicked: mouse => { systemTab.setBrightness(Math.round(mouse.x / width * 100)); }
                                                            onPositionChanged: mouse => { if (pressed) systemTab.setBrightness(Math.round(mouse.x / width * 100)); }
                                                        }
                                                    }
                                                    Text { text: Math.round(systemTab.maxBrightness > 0 ? systemTab.brightness / systemTab.maxBrightness * 100 : 0) + "%"; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter; width: 50 }
                                                }
                                            }

                                            // Volume
                                            Column {
                                                width: parent.width
                                                spacing: 8
                                                Row {
                                                    spacing: 10
                                                    Text { text: systemTab.muted ? "\ue04f" : "\ue050"; font.family: iconFont.name; font.pixelSize: 20; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                                    Text { text: "Volume"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                                    Rectangle {
                                                        width: 60; height: 24
                                                        color: muteArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                        border.width: 2; border.color: Config.colors.outline
                                                        Text { anchors.centerIn: parent; text: systemTab.muted ? "Unmute" : "Mute"; font.family: fontMonaco.name; font.pixelSize: 10; color: Config.colors.text }
                                                        MouseArea { id: muteArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: systemTab.toggleMute() }
                                                    }
                                                }
                                                Row {
                                                    spacing: 16
                                                    Rectangle {
                                                        width: 400; height: 28
                                                        color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                        opacity: systemTab.muted ? 0.5 : 1
                                                        Rectangle {
                                                            anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.margins: 3
                                                            width: Math.min(1, systemTab.volume) * (parent.width - 6)
                                                            color: systemTab.volume > 1 ? Config.colors.urgent : Config.colors.accent
                                                        }
                                                        MouseArea {
                                                            anchors.fill: parent
                                                            onClicked: mouse => { systemTab.setVolume(Math.round(mouse.x / width * 100)); }
                                                            onPositionChanged: mouse => { if (pressed) systemTab.setVolume(Math.round(mouse.x / width * 100)); }
                                                        }
                                                    }
                                                    Text { text: Math.round(systemTab.volume * 100) + "%"; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter; width: 50 }
                                                }
                                            }

                                            Rectangle { width: parent.width; height: 2; color: Config.colors.outline; opacity: 0.5 }

                                            // Terminal
                                            Column {
                                                width: parent.width
                                                spacing: 6
                                                Text { text: "Terminal Application"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                                Row {
                                                    spacing: 12
                                                    Rectangle {
                                                        width: 280; height: 28
                                                        color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                        TextInput {
                                                            id: terminalInput
                                                            anchors.fill: parent; anchors.margins: 5
                                                            text: Config.hyprlandTerminal
                                                            font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text
                                                            clip: true; selectByMouse: true; activeFocusOnPress: true
                                                            verticalAlignment: TextInput.AlignVCenter
                                                        }
                                                    }
                                                    Rectangle {
                                                        width: 60; height: 28
                                                        color: termSaveArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                        border.width: 2; border.color: Config.colors.outline
                                                        Text { anchors.centerIn: parent; text: "Save"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                                        MouseArea { id: termSaveArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.setHyprlandTerminal(terminalInput.text) }
                                                    }
                                                }
                                            }

                                            // File Manager
                                            Column {
                                                width: parent.width
                                                spacing: 6
                                                Text { text: "File Manager Application"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                                Row {
                                                    spacing: 12
                                                    Rectangle {
                                                        width: 280; height: 28
                                                        color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                        TextInput {
                                                            id: filesInput
                                                            anchors.fill: parent; anchors.margins: 5
                                                            text: Config.hyprlandFileManager
                                                            font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text
                                                            clip: true; selectByMouse: true; activeFocusOnPress: true
                                                            verticalAlignment: TextInput.AlignVCenter
                                                        }
                                                    }
                                                    Rectangle {
                                                        width: 60; height: 28
                                                        color: filesSaveArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                        border.width: 2; border.color: Config.colors.outline
                                                        Text { anchors.centerIn: parent; text: "Save"; font.family: fontCharcoal.name; font.pixelSize: 11; color: Config.colors.text }
                                                        MouseArea { id: filesSaveArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.setHyprlandFileManager(filesInput.text) }
                                                    }
                                                }
                                            }

                                            Rectangle { width: parent.width; height: 2; color: Config.colors.outline; opacity: 0.5 }

                                            Text { text: "System Information"; font.family: fontCharcoal.name; font.pixelSize: 14; font.bold: true; color: Config.colors.text }

                                            Grid {
                                                columns: 2; columnSpacing: 16; rowSpacing: 8
                                                Text { text: "OS:"; font.family: fontCharcoal.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: Config.settings.systemDetails.osName; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: "CPU:"; font.family: fontCharcoal.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: Config.settings.systemDetails.cpu; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: "GPU:"; font.family: fontCharcoal.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: Config.settings.systemDetails.gpu; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: "RAM:"; font.family: fontCharcoal.name; font.pixelSize: 12; color: Config.colors.text }
                                                Text { text: Config.settings.systemDetails.ram; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text }
                                            }
                                        }
                                    }
                                }

                                // === NETWORK TAB ===
                                Item {
                                    id: networkTab
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    visible: settingsWindow.currentTab === 2

                                    property var wifiList: []
                                    property string currentWifi: ""
                                    property bool wifiEnabled: true
                                    property bool scanning: false

                                    Component.onCompleted: refreshNetworks()

                                    property string wifiOutput: ""
                                    property string wifiStatusOutput: ""

                                    Process {
                                        id: wifiListProc
                                        command: ["bash", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list 2>/dev/null"]
                                        stdout: SplitParser {
                                            onRead: data => { networkTab.wifiOutput += data + "\n"; }
                                        }
                                        onExited: {
                                            var lines = networkTab.wifiOutput.trim().split('\n');
                                            var networks = [];
                                            networkTab.currentWifi = "";
                                            for (var i = 0; i < lines.length; i++) {
                                                var parts = lines[i].split(':');
                                                if (parts[0] && parts[0].trim() !== "") {
                                                    var net = { ssid: parts[0], signal: parseInt(parts[1]) || 0, security: parts[2] || "", active: parts[3] === "*" };
                                                    networks.push(net);
                                                    if (net.active) networkTab.currentWifi = net.ssid;
                                                }
                                            }
                                            networkTab.wifiList = networks;
                                            networkTab.scanning = false;
                                            networkTab.wifiOutput = "";
                                        }
                                    }

                                    Process {
                                        id: wifiStatusProc
                                        command: ["nmcli", "radio", "wifi"]
                                        stdout: SplitParser {
                                            onRead: data => { networkTab.wifiStatusOutput = data.trim(); }
                                        }
                                        onExited: {
                                            networkTab.wifiEnabled = networkTab.wifiStatusOutput === "enabled";
                                        }
                                    }

                                    Process {
                                        id: wifiToggleProc
                                        onExited: { Qt.callLater(networkTab.refreshNetworks); }
                                    }

                                    Process {
                                        id: wifiConnectProc
                                    }

                                    function refreshNetworks() {
                                        scanning = true;
                                        wifiListProc.running = true;
                                        wifiStatusProc.running = true;
                                    }

                                    function toggleWifi() {
                                        wifiToggleProc.command = ["nmcli", "radio", "wifi", wifiEnabled ? "off" : "on"];
                                        wifiToggleProc.running = true;
                                    }

                                    function connectToNetwork(ssid) {
                                        wifiConnectProc.command = ["nmcli", "device", "wifi", "connect", ssid];
                                        wifiConnectProc.running = true;
                                    }

                                    Column {
                                        anchors.fill: parent
                                        spacing: 16

                                        Row {
                                            width: parent.width
                                            spacing: 16
                                            Text { text: "WiFi"; font.family: fontCharcoal.name; font.pixelSize: 16; font.bold: true; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                            Item { width: parent.width - 200; height: 1 }
                                            Rectangle {
                                                width: 56; height: 28
                                                color: networkTab.wifiEnabled ? Config.colors.accent : Config.colors.shadow
                                                border.width: 2; border.color: Config.colors.outline
                                                Rectangle {
                                                    width: 22; height: 22; y: 3
                                                    x: networkTab.wifiEnabled ? 31 : 3
                                                    color: Config.colors.highlight; border.width: 2; border.color: Config.colors.outline
                                                    Behavior on x { NumberAnimation { duration: 150 } }
                                                }
                                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: networkTab.toggleWifi() }
                                            }
                                            Rectangle {
                                                width: 36; height: 36
                                                color: refreshArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                border.width: 2; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: "\ue5d5"; font.family: iconFont.name; font.pixelSize: 20; color: Config.colors.text; rotation: networkTab.scanning ? 360 : 0; Behavior on rotation { RotationAnimation { duration: 500 } } }
                                                MouseArea { id: refreshArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: networkTab.refreshNetworks() }
                                            }
                                        }

                                        Rectangle { width: parent.width; height: 2; color: Config.colors.outline; opacity: 0.5 }

                                        Rectangle {
                                            width: parent.width; height: parent.height - 80
                                            color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                            clip: true

                                            ListView {
                                                id: wifiListView
                                                anchors.fill: parent; anchors.margins: 6
                                                model: networkTab.wifiList
                                                spacing: 4

                                                delegate: Rectangle {
                                                    width: wifiListView.width
                                                    height: 40
                                                    color: modelData.active ? Config.colors.accent : (wifiItemArea.containsMouse ? Config.colors.highlight : "transparent")
                                                    
                                                    Row {
                                                        anchors.fill: parent; anchors.margins: 8; spacing: 12
                                                        Text {
                                                            text: modelData.signal > 75 ? "\ue1d8" : (modelData.signal > 50 ? "\uebe4" : (modelData.signal > 25 ? "\uebe1" : "\uf065"))
                                                            font.family: iconFont.name; font.pixelSize: 22; color: modelData.active ? Config.colors.base : Config.colors.text
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                        Text { text: modelData.ssid; font.family: fontMonaco.name; font.pixelSize: 14; color: modelData.active ? Config.colors.base : Config.colors.text; anchors.verticalCenter: parent.verticalCenter; elide: Text.ElideRight; width: 320 }
                                                        Text { text: modelData.security !== "" ? "\ue897" : ""; font.family: iconFont.name; font.pixelSize: 18; color: modelData.active ? Config.colors.base : Config.colors.text; anchors.verticalCenter: parent.verticalCenter; opacity: 0.6 }
                                                        Text { text: modelData.signal + "%"; font.family: fontMonaco.name; font.pixelSize: 13; color: modelData.active ? Config.colors.base : Config.colors.text; anchors.verticalCenter: parent.verticalCenter; opacity: 0.6 }
                                                    }
                                                    MouseArea { id: wifiItemArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onDoubleClicked: networkTab.connectToNetwork(modelData.ssid) }
                                                }
                                            }

                                            Text {
                                                anchors.centerIn: parent
                                                visible: networkTab.wifiList.length === 0
                                                text: networkTab.scanning ? "Scanning..." : (networkTab.wifiEnabled ? "No networks found" : "WiFi disabled")
                                                font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; opacity: 0.5
                                            }
                                        }

                                        Text { text: "Double-click to connect"; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text; opacity: 0.4 }
                                    }
                                }

                                // === BLUETOOTH TAB ===
                                Item {
                                    id: bluetoothTab
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    visible: settingsWindow.currentTab === 3

                                    property var deviceList: []
                                    property bool btEnabled: true
                                    property bool scanning: false
                                    property var pendingDevices: []

                                    Component.onCompleted: refreshDevices()

                                    property string btStatusOutput: ""
                                    property string btDevicesOutput: ""

                                    Process {
                                        id: btStatusProc
                                        command: ["bash", "-c", "bluetoothctl show 2>/dev/null | grep 'Powered:' | awk '{print $2}'"]
                                        stdout: SplitParser {
                                            onRead: data => { bluetoothTab.btStatusOutput = data.trim(); }
                                        }
                                        onExited: {
                                            bluetoothTab.btEnabled = bluetoothTab.btStatusOutput === "yes";
                                        }
                                    }

                                    Process {
                                        id: btDevicesProc
                                        command: ["bluetoothctl", "devices"]
                                        stdout: SplitParser {
                                            onRead: data => { bluetoothTab.btDevicesOutput += data + "\n"; }
                                        }
                                        onExited: {
                                            var lines = bluetoothTab.btDevicesOutput.trim().split('\n');
                                            var devices = [];
                                            for (var i = 0; i < lines.length; i++) {
                                                var match = lines[i].match(/Device ([A-Fa-f0-9:]+) (.+)/);
                                                if (match) {
                                                    devices.push({ mac: match[1], name: match[2], connected: false });
                                                }
                                            }
                                            bluetoothTab.deviceList = devices;
                                            bluetoothTab.scanning = false;
                                            bluetoothTab.btDevicesOutput = "";
                                        }
                                    }

                                    Process {
                                        id: btToggleProc
                                        onExited: { Qt.callLater(bluetoothTab.refreshDevices); }
                                    }

                                    Process {
                                        id: btConnectProc
                                    }

                                    Process {
                                        id: btScanProc
                                        command: ["bluetoothctl", "--timeout", "5", "scan", "on"]
                                        onExited: { bluetoothTab.refreshDevices(); }
                                    }

                                    function refreshDevices() {
                                        scanning = true;
                                        btStatusProc.running = true;
                                        btDevicesProc.running = true;
                                    }

                                    function toggleBluetooth() {
                                        btToggleProc.command = ["bluetoothctl", "power", btEnabled ? "off" : "on"];
                                        btToggleProc.running = true;
                                    }

                                    function connectDevice(mac) {
                                        btConnectProc.command = ["bluetoothctl", "connect", mac];
                                        btConnectProc.running = true;
                                    }

                                    function disconnectDevice(mac) {
                                        btConnectProc.command = ["bluetoothctl", "disconnect", mac];
                                        btConnectProc.running = true;
                                    }

                                    function startScan() {
                                        btScanProc.running = true;
                                    }

                                    Column {
                                        anchors.fill: parent
                                        spacing: 16

                                        Row {
                                            width: parent.width
                                            spacing: 16
                                            Text { text: "Bluetooth"; font.family: fontCharcoal.name; font.pixelSize: 16; font.bold: true; color: Config.colors.text; anchors.verticalCenter: parent.verticalCenter }
                                            Item { width: parent.width - 240; height: 1 }
                                            Rectangle {
                                                width: 56; height: 28
                                                color: bluetoothTab.btEnabled ? Config.colors.accent : Config.colors.shadow
                                                border.width: 2; border.color: Config.colors.outline
                                                Rectangle {
                                                    width: 22; height: 22; y: 3
                                                    x: bluetoothTab.btEnabled ? 31 : 3
                                                    color: Config.colors.highlight; border.width: 2; border.color: Config.colors.outline
                                                    Behavior on x { NumberAnimation { duration: 150 } }
                                                }
                                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: bluetoothTab.toggleBluetooth() }
                                            }
                                            Rectangle {
                                                width: 36; height: 36
                                                color: btScanArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                border.width: 2; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: "\ue1a7"; font.family: iconFont.name; font.pixelSize: 20; color: Config.colors.text }
                                                MouseArea { id: btScanArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: bluetoothTab.startScan() }
                                            }
                                            Rectangle {
                                                width: 36; height: 36
                                                color: btRefreshArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                border.width: 2; border.color: Config.colors.outline
                                                Text { anchors.centerIn: parent; text: "\ue5d5"; font.family: iconFont.name; font.pixelSize: 20; color: Config.colors.text }
                                                MouseArea { id: btRefreshArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: bluetoothTab.refreshDevices() }
                                            }
                                        }

                                        Rectangle { width: parent.width; height: 2; color: Config.colors.outline; opacity: 0.5 }

                                        Rectangle {
                                            width: parent.width; height: parent.height - 80
                                            color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                            clip: true

                                            ListView {
                                                id: btListView
                                                anchors.fill: parent; anchors.margins: 6
                                                model: bluetoothTab.deviceList
                                                spacing: 4

                                                delegate: Rectangle {
                                                    width: btListView.width
                                                    height: 48
                                                    color: modelData.connected ? Config.colors.accent : (btItemArea.containsMouse ? Config.colors.highlight : "transparent")
                                                    
                                                    Row {
                                                        anchors.fill: parent; anchors.margins: 8; spacing: 12
                                                        Text {
                                                            text: "\ue1a7"
                                                            font.family: iconFont.name; font.pixelSize: 24; color: modelData.connected ? Config.colors.base : Config.colors.text
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                        Column {
                                                            anchors.verticalCenter: parent.verticalCenter; spacing: 2
                                                            Text { text: modelData.name; font.family: fontMonaco.name; font.pixelSize: 14; color: modelData.connected ? Config.colors.base : Config.colors.text; elide: Text.ElideRight; width: 350 }
                                                            Text { text: modelData.mac; font.family: fontMonaco.name; font.pixelSize: 11; color: modelData.connected ? Config.colors.base : Config.colors.text; opacity: 0.5 }
                                                        }
                                                        Text { text: modelData.connected ? "Connected" : ""; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.base; anchors.verticalCenter: parent.verticalCenter }
                                                    }
                                                    MouseArea { 
                                                        id: btItemArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                                        onDoubleClicked: modelData.connected ? bluetoothTab.disconnectDevice(modelData.mac) : bluetoothTab.connectDevice(modelData.mac)
                                                    }
                                                }
                                            }

                                            Text {
                                                anchors.centerIn: parent
                                                visible: bluetoothTab.deviceList.length === 0
                                                text: bluetoothTab.scanning ? "Scanning..." : (bluetoothTab.btEnabled ? "No devices found\nClick scan to discover" : "Bluetooth disabled")
                                                font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; opacity: 0.5; horizontalAlignment: Text.AlignHCenter
                                            }
                                        }

                                        Text { text: "Double-click to connect/disconnect"; font.family: fontMonaco.name; font.pixelSize: 12; color: Config.colors.text; opacity: 0.4 }
                                    }
                                }

                                // === ABOUT TAB ===
                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    visible: settingsWindow.currentTab === 4

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 18
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Linux Retroism"; font.family: fontCharcoal.name; font.pixelSize: 28; color: Config.colors.text }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Version " + Config.settings.version; font.family: fontMonaco.name; font.pixelSize: 16; color: Config.colors.text }
                                        Rectangle { width: 300; height: 2; color: Config.colors.outline; anchors.horizontalCenter: parent.horizontalCenter }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "A 1980-1990's retro UI aesthetic\nfor Hyprland & Sway"; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text; horizontalAlignment: Text.AlignHCenter }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Created by diinki"; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.accent }
                                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "github.com/diinki/linux-retroism"; font.family: fontMonaco.name; font.pixelSize: 13; color: Config.colors.text; opacity: 0.6 }
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
            
            Process {
                id: powerCmdProc
            }

            Process {
                id: hyprlockThemeProc
            }

            function updateHyprlockTheme() {
                var c = Config.colors;
                var sedArgs = [
                    "-i",
                    "-e", "s/outer_color = rgb([^)]*)/outer_color = rgb(" + c.outline.slice(1) + ")/g",
                    "-e", "s/inner_color = rgb([^)]*)/inner_color = rgb(" + c.base.slice(1) + ")/g",
                    "-e", "s/font_color = rgb([^)]*)/font_color = rgb(" + c.text.slice(1) + ")/g",
                    "-e", "s/check_color = rgb([^)]*)/check_color = rgb(" + c.accent.slice(1) + ")/g",
                    "-e", "s/fail_color = rgb([^)]*)/fail_color = rgb(" + c.urgent.slice(1) + ")/g",
                    "/home/ozhan/.config/hypr/hyprlock.conf"
                ];
                hyprlockThemeProc.command = ["sed"].concat(sedArgs);
                hyprlockThemeProc.running = true;
            }

            function runPowerCommand(cmd) {
                var parts = cmd.split(" ");
                powerCmdProc.command = parts;
                powerCmdProc.running = true;
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
                                                powerMenu.runPowerCommand(powerMenu.powerActions[actionKey].cmd);
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
                                            if (powerMenu.powerMenuState !== "") powerMenu.runPowerCommand(powerMenu.powerActions[powerMenu.powerMenuState].cmd);
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

    // ============ NOTIFICATION SERVER ============
    property int notificationCount: 0
    
    NotificationServer {
        id: notificationServer
        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: notification => {
            notification.tracked = true;
            root.notificationCount = trackedNotifications.values.length;
            // Bildirimler manuel olarak kapatılana kadar kalır
        }
    }
    
    Connections {
        target: notificationServer.trackedNotifications
        function onValuesChanged() {
            root.notificationCount = notificationServer.trackedNotifications.values.length;
        }
    }

    // ============ NOTIFICATION POPUP (Top Right) ============
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: notificationPopup
            required property var modelData
            screen: modelData
            visible: root.notificationCount > 0 && Hyprland.focusedMonitor.name === modelData.name && !Config.openNotificationHistory

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "notification-popup"
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                right: true
            }
            implicitWidth: 340
            implicitHeight: Math.max(root.notificationCount * 90, 10)
            margins.top: 50
            margins.right: 10
            color: "transparent"

            Column {
                anchors.fill: parent
                spacing: 8

                Repeater {
                    model: notificationServer.trackedNotifications

                    Rectangle {
                        id: notifCard
                        width: 320
                        height: 80
                        color: Config.colors.base

                        // Outer border (3D effect)
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.width: 2
                            border.color: Config.colors.outline
                        }

                        // Highlight edge (top-left)
                        Rectangle {
                            width: parent.width - 4; height: 2
                            x: 2; y: 2
                            color: Config.colors.highlight
                        }
                        Rectangle {
                            width: 2; height: parent.height - 4
                            x: 2; y: 2
                            color: Config.colors.highlight
                        }

                        // Shadow edge (bottom-right)
                        Rectangle {
                            width: parent.width - 4; height: 2
                            x: 2; y: parent.height - 4
                            color: Config.colors.shadow
                        }
                        Rectangle {
                            width: 2; height: parent.height - 4
                            x: parent.width - 4; y: 2
                            color: Config.colors.shadow
                        }

                        // Title bar
                        Rectangle {
                            id: notifTitleBar
                            x: 4; y: 4
                            width: parent.width - 8; height: 18
                            color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.urgent : Config.colors.accent

                            // Striped pattern
                            Repeater {
                                model: Math.floor((parent.width - 100) / 4)
                                Rectangle {
                                    x: 4 + index * 4
                                    y: 0
                                    width: 2
                                    height: parent.height
                                    color: Qt.rgba(0, 0, 0, 0.2)
                                }
                            }

                            Row {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.rightMargin: 4
                                spacing: 4

                                Text {
                                    text: modelData.appName || "Notification"
                                    font.family: fontCharcoal.name
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: Config.colors.text
                                }

                                // Close button
                                Rectangle {
                                    width: 14; height: 14
                                    color: closeArea.pressed ? Config.colors.shadow : Config.colors.base
                                    border.width: 1
                                    border.color: Config.colors.outline

                                    Text {
                                        anchors.centerIn: parent
                                        text: "×"
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: Config.colors.text
                                    }

                                    MouseArea {
                                        id: closeArea
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: modelData.dismiss()
                                    }
                                }
                            }
                        }

                        // Content
                        Column {
                            x: 10; y: 28
                            width: parent.width - 20
                            spacing: 4

                            Text {
                                width: parent.width
                                text: modelData.summary || ""
                                font.family: fontCharcoal.name
                                font.pixelSize: 13
                                font.bold: true
                                color: Config.colors.text
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width
                                text: modelData.body || ""
                                font.family: fontMonaco.name
                                font.pixelSize: 11
                                color: Config.colors.text
                                opacity: 0.8
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }

                        // Actions
                        Row {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 6
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            spacing: 4
                            visible: modelData.actions.length > 0

                            Repeater {
                                model: modelData.actions
                                Rectangle {
                                    width: actionText.width + 12
                                    height: 16
                                    color: actionArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                    border.width: 1
                                    border.color: Config.colors.outline

                                    Text {
                                        id: actionText
                                        anchors.centerIn: parent
                                        text: modelData.text
                                        font.family: fontCharcoal.name
                                        font.pixelSize: 8
                                        color: Config.colors.text
                                    }

                                    MouseArea {
                                        id: actionArea
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: modelData.invoke()
                                    }
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            z: -1
                            onClicked: modelData.dismiss()
                        }
                    }
                }
            }
        }
    }

    // ============ NOTIFICATION HISTORY PANEL (Right Side) ============
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: notificationHistoryPanel
            required property var modelData
            screen: modelData
            visible: Config.openNotificationHistory && Hyprland.focusedMonitor.name === modelData.name

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            WlrLayershell.namespace: "notification-history"

            anchors {
                top: true
                bottom: true
                right: true
            }
            implicitWidth: 380
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                anchors.margins: 0
                color: Config.colors.base

                // Outer border
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 3
                    border.color: Config.colors.outline
                }

                // Highlight edge
                Rectangle {
                    width: parent.width - 6; height: 3
                    x: 3; y: 3
                    color: Config.colors.highlight
                }
                Rectangle {
                    width: 3; height: parent.height - 6
                    x: 3; y: 3
                    color: Config.colors.highlight
                }

                // Shadow edge
                Rectangle {
                    width: parent.width - 6; height: 3
                    x: 3; y: parent.height - 6
                    color: Config.colors.shadow
                }
                Rectangle {
                    width: 3; height: parent.height - 6
                    x: parent.width - 6; y: 3
                    color: Config.colors.shadow
                }

                // Title bar
                Rectangle {
                    id: historyTitleBar
                    x: 6; y: 6
                    width: parent.width - 12; height: 28
                    color: Config.colors.accent

                    // Striped pattern
                    Repeater {
                        model: Math.floor((parent.width - 150) / 4)
                        Rectangle {
                            x: 4 + index * 4
                            y: 0
                            width: 2
                            height: parent.height
                            color: Qt.rgba(0, 0, 0, 0.2)
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 6
                        spacing: 8

                        Text {
                            text: "\ue7f5"
                            font.family: iconFont.name
                            font.pixelSize: 16
                            color: Config.colors.text
                        }

                        Text {
                            text: "Notifications"
                            font.family: fontCharcoal.name
                            font.pixelSize: 14
                            font.bold: true
                            color: Config.colors.text
                        }

                        // Close button
                        Rectangle {
                            width: 20; height: 20
                            color: historyCloseArea.pressed ? Config.colors.shadow : Config.colors.base
                            border.width: 1
                            border.color: Config.colors.outline

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 1
                                anchors.bottomMargin: 2
                                anchors.rightMargin: 2
                                color: "transparent"
                                border.width: 1
                                border.color: Config.colors.highlight
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "×"
                                font.pixelSize: 14
                                font.bold: true
                                color: Config.colors.text
                            }

                            MouseArea {
                                id: historyCloseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Config.openNotificationHistory = false
                            }
                        }
                    }
                }

                // Clear All button
                Rectangle {
                    x: 6; y: 40
                    width: parent.width - 12; height: 24
                    color: clearAllArea.pressed ? Config.colors.shadow : Config.colors.highlight
                    border.width: 1
                    border.color: Config.colors.outline
                    visible: root.notificationCount > 0

                    Text {
                        anchors.centerIn: parent
                        text: "Clear All (" + root.notificationCount + ")"
                        font.family: fontCharcoal.name
                        font.pixelSize: 10
                        color: Config.colors.text
                    }

                    MouseArea {
                        id: clearAllArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            let notifications = notificationServer.trackedNotifications.values.slice();
                            for (let notif of notifications) {
                                notif.dismiss();
                            }
                        }
                    }
                }

                // Notification list
                Flickable {
                    x: 6; y: root.notificationCount > 0 ? 70 : 40
                    width: parent.width - 12
                    height: parent.height - y - 10
                    contentHeight: historyColumn.height
                    clip: true

                    Column {
                        id: historyColumn
                        width: parent.width
                        spacing: 8

                        // Empty state
                        Text {
                            width: parent.width
                            visible: root.notificationCount === 0
                            text: "No notifications"
                            font.family: fontMonaco.name
                            font.pixelSize: 12
                            color: Config.colors.shadow
                            horizontalAlignment: Text.AlignHCenter
                            topPadding: 40
                        }

                        Repeater {
                            model: notificationServer.trackedNotifications

                            Rectangle {
                                width: parent.width
                                height: 70
                                color: Config.colors.shadow

                                // Border
                                Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                    border.width: 1
                                    border.color: Config.colors.outline
                                }

                                // Urgency indicator
                                Rectangle {
                                    width: 4
                                    height: parent.height
                                    color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.urgent :
                                           modelData.urgency === NotificationUrgency.Low ? Config.colors.highlight : Config.colors.accent
                                }

                                // Content
                                Column {
                                    x: 12; y: 8
                                    width: parent.width - 40
                                    spacing: 4

                                    Row {
                                        width: parent.width
                                        spacing: 8

                                        Text {
                                            text: modelData.appName || "App"
                                            font.family: fontCharcoal.name
                                            font.pixelSize: 9
                                            font.bold: true
                                            color: Config.colors.accent
                                        }
                                    }

                                    Text {
                                        width: parent.width
                                        text: modelData.summary || ""
                                        font.family: fontCharcoal.name
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: Config.colors.text
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.width
                                        text: modelData.body || ""
                                        font.family: fontMonaco.name
                                        font.pixelSize: 11
                                        color: Config.colors.text
                                        opacity: 0.8
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                    }
                                }

                                // Dismiss button
                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.margins: 6
                                    width: 18; height: 18
                                    color: historyDismissArea.pressed ? Config.colors.shadow : Config.colors.base
                                    border.width: 1
                                    border.color: Config.colors.outline

                                    Text {
                                        anchors.centerIn: parent
                                        text: "×"
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: Config.colors.text
                                    }

                                    MouseArea {
                                        id: historyDismissArea
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: modelData.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
