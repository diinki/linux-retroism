import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import ".."

/* NOTE:
*  This entire module is quite a mess, and is likely going to get a complete re-write.
*  I'm experimenting with creating the entire window frame/designs with SVG in order to
*  skip the need of creating everything out of rectangles and borders.
*/
PopupWindow {
    id: root

    property int menuWidth: 0
    property var closeCallback: function () {}
    anchor.window: taskbar
    anchor.rect.x: menuWidth
    anchor.rect.y: parentWindow.implicitHeight
    implicitWidth: 480
    implicitHeight: 276
    color: "transparent"

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base
        layer.enabled: true

        property int topOffset: 20

        PopupWindowFrame {
            id: startMenuFrame
            windowTitle: "Your Computer"
            windowTitleIcon: "\ue30c"
            windowTitleDecorationWidth: 150
            Item {
                id: content
                anchors.fill: startMenuFrame
                anchors.margins: 18
                anchors.topMargin: frame.topOffset + 18

                ColumnLayout {
                    spacing: 8
                    RowLayout {
                        spacing: 8
                        implicitWidth: content.width

                        Item {
                            implicitWidth: 150
                            implicitHeight: 150
                            Image {
                                asynchronous: true
                                anchors.fill: parent
                                source: Config.settings.systemProfileImageSource
                                fillMode: Image.PreserveAspectCrop
                                clip: true
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: Config.colors.outline
                                border.width: 1
                            }
                        }
                        Item {
                            id: headerContent
                            Layout.fillWidth: true
                            implicitHeight: 150
                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: Config.colors.outline
                                border.width: 1
                            }

                            Item {
                                anchors.fill: parent
                                anchors.margins: 8
                                ColumnLayout {
                                    spacing: 8

                                    RowLayout {
                                        spacing: 8
                                        Text {
                                            font.family: iconFont.name
                                            font.pixelSize: 16
                                            text: "\ue161"
                                            color: Config.colors.text
                                        }
                                        Text {
                                            font.family: fontMonaco.name
                                            font.pixelSize: 14
                                            text: Config.settings.systemDetails.osName
                                            color: Config.colors.text
                                        }
                                    }
                                    RowLayout {
                                        spacing: 8
                                        Text {
                                            font.family: iconFont.name
                                            font.pixelSize: 16
                                            text: "\ue394"
                                            color: Config.colors.text
                                        }
                                        Text {
                                            font.family: fontMonaco.name
                                            font.pixelSize: 14
                                            text: Config.settings.systemDetails.osVersion
                                            color: Config.colors.text
                                        }
                                    }
                                    RowLayout {
                                        spacing: 8
                                        Text {
                                            font.family: iconFont.name
                                            font.pixelSize: 16
                                            text: "\uf7a3"
                                            color: Config.colors.text
                                        }
                                        Text {
                                            font.family: fontMonaco.name
                                            font.pixelSize: 14
                                            text: Config.settings.systemDetails.ram
                                            color: Config.colors.text
                                        }
                                    }
                                    RowLayout {
                                        spacing: 8
                                        Text {
                                            font.family: iconFont.name
                                            font.pixelSize: 16
                                            text: "\ue322"
                                            color: Config.colors.text
                                        }
                                        Text {
                                            font.family: fontMonaco.name
                                            font.pixelSize: 14
                                            text: Config.settings.systemDetails.cpu
                                            color: Config.colors.text
                                        }
                                    }
                                    RowLayout {
                                        spacing: 8
                                        Text {
                                            font.family: iconFont.name
                                            font.pixelSize: 16
                                            text: "\ue2ac"
                                            color: Config.colors.text
                                        }

                                        Text {
                                            font.family: fontMonaco.name
                                            font.pixelSize: 14
                                            text: Config.settings.systemDetails.gpu
                                            color: Config.colors.text
                                        }
                                    }
                                }
                            }
                        }
                    }
                    RowLayout {
                        spacing: 8
                        implicitWidth: content.width

                        Item {
                            implicitWidth: 150
                            implicitHeight: 60
                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: Config.colors.outline
                                border.width: 1
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 60
                            Layout.leftMargin: 1
                            RowLayout {
                                spacing: 14

                                Button {
                                    id: filesButton
                                    implicitHeight: 60
                                    implicitWidth: 60

                                    onClicked: () => {
                                        Quickshell.execDetached(Config.hyprlandFileManager);
                                        root.closeCallback();
                                    }

                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: Config.colors.outline
                                        opacity: mouse0.hovered ? (0.2 + (filesButton.pressed ? 0.2 : 0.0)) : 0.1
                                        border.width: 1
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 2
                                        tBorderwidth: 2
                                        bBorderwidth: 2
                                        zValue: -1
                                        borderColor: Config.colors.shadow
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 0
                                        tBorderwidth: 2
                                        bBorderwidth: 0
                                        zValue: -1
                                        opacity: 0.8
                                        borderColor: Config.colors.highlight
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        font.family: iconFont.name
                                        font.pixelSize: 48
                                        opacity: 0.4
                                        color: Config.colors.text
                                        text: "\ue2c7"
                                    }
                                    HoverHandler {
                                        id: mouse0
                                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                                Button {
                                    id: terminalButton
                                    implicitHeight: 60
                                    implicitWidth: 60

                                    onClicked: () => {
                                        Quickshell.execDetached(Config.hyprlandTerminal);
                                        root.closeCallback();
                                    }

                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: Config.colors.outline
                                        opacity: mouse.hovered ? (0.2 + (terminalButton.pressed ? 0.2 : 0.0)) : 0.1
                                        border.width: 1
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 2
                                        tBorderwidth: 2
                                        bBorderwidth: 2
                                        zValue: -1
                                        borderColor: Config.colors.shadow
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 0
                                        tBorderwidth: 2
                                        bBorderwidth: 0
                                        zValue: -1
                                        opacity: 0.8
                                        borderColor: Config.colors.highlight
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        font.family: iconFont.name
                                        font.pixelSize: 48
                                        opacity: 0.4
                                        color: Config.colors.text
                                        text: "\ueb8e"
                                    }
                                    HoverHandler {
                                        id: mouse
                                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                                Button {
                                    id: settingsButton
                                    implicitHeight: 60
                                    implicitWidth: 60

                                    onClicked: () => {
                                        Config.openSettingsWindow = true;
                                        root.closeCallback();
                                    }

                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: Config.colors.outline
                                        opacity: mouse2.hovered ? (0.2 + (settingsButton.pressed ? 0.2 : 0.0)) : 0.1
                                        border.width: 1
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 2
                                        tBorderwidth: 2
                                        bBorderwidth: 2
                                        zValue: -1
                                        borderColor: Config.colors.shadow
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 0
                                        tBorderwidth: 2
                                        bBorderwidth: 0
                                        zValue: -1
                                        opacity: 0.8
                                        borderColor: Config.colors.highlight
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        font.family: iconFont.name
                                        font.pixelSize: 48
                                        opacity: 0.4
                                        color: Config.colors.text
                                        text: "\ue8b8"
                                    }
                                    HoverHandler {
                                        id: mouse2
                                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                                Button {
                                    id: powerButton
                                    implicitHeight: 60
                                    implicitWidth: 60

                                    onClicked: () => {
                                        Config.openPowerMenu = true;
                                        root.closeCallback();
                                    }

                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: Config.colors.outline
                                        opacity: mouse3.hovered ? (0.2 + (powerButton.pressed ? 0.2 : 0.0)) : 0.1
                                        border.width: 1
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 2
                                        tBorderwidth: 2
                                        bBorderwidth: 2
                                        zValue: -1
                                        borderColor: Config.colors.shadow
                                    }
                                    NewBorder {
                                        commonBorderWidth: 2
                                        commonBorder: false
                                        lBorderwidth: 2
                                        rBorderwidth: 0
                                        tBorderwidth: 2
                                        bBorderwidth: 0
                                        zValue: -1
                                        opacity: 0.8
                                        borderColor: Config.colors.highlight
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        font.family: iconFont.name
                                        font.pixelSize: 48
                                        opacity: 0.4
                                        color: Config.colors.text
                                        text: "\uf418"
                                    }
                                    HoverHandler {
                                        id: mouse3
                                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        /*=== Animations ===*/
        OpacityAnimator {
            id: openAnimation
            target: frame
            from: 0
            to: 1
            duration: 140
            easing.type: Easing.OutCubic
        }
        OpacityAnimator {
            id: closeAnimation
            target: frame
            from: 1
            to: 0
            duration: 80
            easing.type: Easing.InOutQuad
            onFinished: root.visible = false
        }
    }

    function openStartMenu() {
        root.visible = true;
        openAnimation.start();
    }

    function closeStartMenu() {
        closeAnimation.start();
    }
}
