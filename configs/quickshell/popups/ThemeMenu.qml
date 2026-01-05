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
    anchor.window: taskbar
    anchor.rect.x: menuWidth
    anchor.rect.y: parentWindow.implicitHeight
    implicitWidth: 600
    implicitHeight: 182
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
            windowTitle: "Themes"
            windowTitleIcon: "\ue40a"
            windowTitleDecorationWidth: 235
            Item {
                id: content
                anchors.fill: startMenuFrame
                anchors.margins: 8
                anchors.topMargin: frame.topOffset + 20
                clip: true

                ColumnLayout {
                    spacing: 0
                    Item {
                        implicitHeight: 110
                        implicitWidth: startMenuFrame.width

                        Flickable {
                            id: flickable
                            width: parent.width
                            height: 105

                            contentWidth: row.width + 5 * Object.keys(Config.themes).length
                            contentHeight: row.height

                            flickableDirection: Flickable.HorizontalFlick
                            boundsBehavior: Flickable.DragOverBounds
                            maximumFlickVelocity: 3500

                            property int themeColorShowWidth: 12

                            RowLayout {
                                id: row
                                spacing: 10
                                height: parent.height

                                Repeater {
                                    model: Object.keys(Config.themes)
                                    Button {
                                        implicitWidth: 150
                                        implicitHeight: 100
                                        //color: "lightcoral"
                                        //border.color: "darkred"
                                        opacity: pressed ? 0.6 : 1
                                        clip: true

                                        onReleased: () => {
                                            Config.settings.currentTheme = modelData;
                                            Quickshell.execDetached(["kitty", "+kitten", "themes", "--reload-in", "all", modelData+"theme"]);
                                        }

                                        background: Rectangle {
                                            anchors.fill: parent
                                            color: mouse.hovered ? Config.colors.shadow : Config.colors.base
                                            border.width: 1
                                        }
                                        NewBorder {
                                            commonBorderWidth: 2
                                            commonBorder: false
                                            lBorderwidth: 0
                                            rBorderwidth: 1
                                            tBorderwidth: 0
                                            bBorderwidth: 1
                                            zValue: -1
                                            borderColor: Config.colors.outline
                                        }
                                        ColumnLayout {
                                            width: parent.width
                                            height: parent.height
                                            spacing: 0
                                            RowLayout {
                                                Layout.alignment: Qt.AlignHCenter
                                                spacing: 0
                                                Rectangle {
                                                    implicitWidth: flickable.themeColorShowWidth
                                                    implicitHeight: 50
                                                    color: Config.themes[modelData].base
                                                    border.width: Config.settings.currentTheme == modelData ? 1 : 0
                                                }
                                                Rectangle {
                                                    implicitWidth: flickable.themeColorShowWidth
                                                    implicitHeight: 50
                                                    color: Config.themes[modelData].accent
                                                    border.width: 0
                                                }
                                                Rectangle {
                                                    implicitWidth: flickable.themeColorShowWidth
                                                    implicitHeight: 50
                                                    color: Config.themes[modelData].highlight
                                                    border.width: 0
                                                }
                                                Rectangle {
                                                    implicitWidth: flickable.themeColorShowWidth
                                                    implicitHeight: 50
                                                    color: Config.themes[modelData].shadow
                                                    border.width: 0
                                                }
                                                Rectangle {
                                                    implicitWidth: flickable.themeColorShowWidth
                                                    implicitHeight: 50
                                                    color: Config.themes[modelData].text
                                                    border.width: 0
                                                }
                                            }
                                            Text {
                                                Layout.alignment: Qt.AlignHCenter
                                                font.family: fontMonaco.name
                                                font.pixelSize: 16
                                                text: modelData
                                            }
                                        }
                                        HoverHandler {
                                            id: mouse
                                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                    }
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.NoButton

                            onWheel: function (wheel) {
                                var delta = wheel.angleDelta.y * 0.2;
                                flickable.contentX = Math.max(0, Math.min(flickable.contentWidth - flickable.width, flickable.contentX - delta));
                            }
                        }
                    }

                    Item {
                        Layout.leftMargin: 8
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 6

                            Text {
                                font.family: fontCharcoal.name
                                font.pixelSize: 13
                                text: "Current Theme:"
                            }
                            Text {
                                font.family: fontMonaco.name
                                font.pixelSize: 13
                                text: Config.settings.currentTheme
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

    function openThemeMenu() {
        root.visible = true;
        openAnimation.start();
    }

    function closeThemeMenu() {
        closeAnimation.start();
        Config.currentPopup = Config.SystemPopup.None;
    }
}
