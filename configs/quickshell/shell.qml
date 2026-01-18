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
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    visible: settingsWindow.currentTab === 1

                                    Column {
                                        anchors.fill: parent
                                        spacing: 20

                                        // Terminal
                                        Column {
                                            width: parent.width
                                            spacing: 8
                                            Text { text: "Terminal Application"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text }
                                            Row {
                                                spacing: 12
                                                Rectangle {
                                                    width: 280; height: 32
                                                    color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                    TextInput {
                                                        id: terminalInput
                                                        anchors.fill: parent; anchors.margins: 6
                                                        text: Config.hyprlandTerminal
                                                        font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text
                                                        clip: true; selectByMouse: true; activeFocusOnPress: true
                                                        verticalAlignment: TextInput.AlignVCenter
                                                    }
                                                }
                                                Rectangle {
                                                    width: 70; height: 32
                                                    color: termSaveArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                    border.width: 2; border.color: Config.colors.outline
                                                    Text { anchors.centerIn: parent; text: "Save"; font.family: fontCharcoal.name; font.pixelSize: 13; color: Config.colors.text }
                                                    MouseArea { id: termSaveArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.setHyprlandTerminal(terminalInput.text) }
                                                }
                                            }
                                            Text { text: "→ hyprland.conf: $terminal"; font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text; opacity: 0.5 }
                                        }

                                        // File Manager
                                        Column {
                                            width: parent.width
                                            spacing: 8
                                            Text { text: "File Manager Application"; font.family: fontCharcoal.name; font.pixelSize: 15; color: Config.colors.text }
                                            Row {
                                                spacing: 12
                                                Rectangle {
                                                    width: 280; height: 32
                                                    color: Config.colors.shadow; border.width: 2; border.color: Config.colors.outline
                                                    TextInput {
                                                        id: filesInput
                                                        anchors.fill: parent; anchors.margins: 6
                                                        text: Config.hyprlandFileManager
                                                        font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text
                                                        clip: true; selectByMouse: true; activeFocusOnPress: true
                                                        verticalAlignment: TextInput.AlignVCenter
                                                    }
                                                }
                                                Rectangle {
                                                    width: 70; height: 32
                                                    color: filesSaveArea.pressed ? Config.colors.shadow : Config.colors.highlight
                                                    border.width: 2; border.color: Config.colors.outline
                                                    Text { anchors.centerIn: parent; text: "Save"; font.family: fontCharcoal.name; font.pixelSize: 13; color: Config.colors.text }
                                                    MouseArea { id: filesSaveArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Config.setHyprlandFileManager(filesInput.text) }
                                                }
                                            }
                                            Text { text: "→ hyprland.conf: $fileManager"; font.family: fontMonaco.name; font.pixelSize: 11; color: Config.colors.text; opacity: 0.5 }
                                        }

                                        Rectangle { width: parent.width; height: 2; color: Config.colors.outline; opacity: 0.5 }

                                        Text { text: "System Information"; font.family: fontCharcoal.name; font.pixelSize: 16; font.bold: true; color: Config.colors.text }

                                        Grid {
                                            columns: 2; columnSpacing: 20; rowSpacing: 12
                                            Text { text: "OS:"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.osName; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: "Version:"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.osVersion; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: "CPU:"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.cpu; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: "GPU:"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.gpu; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: "RAM:"; font.family: fontCharcoal.name; font.pixelSize: 14; color: Config.colors.text }
                                            Text { text: Config.settings.systemDetails.ram; font.family: fontMonaco.name; font.pixelSize: 14; color: Config.colors.text }
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
}
