import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell.Wayland
import ".."
import "../utils" as Utils

/* NOTE:
*  This entire module is quite a mess, and is likely going to get a complete re-write.
*  I'm experimenting with creating the entire window frame/designs with SVG in order to
*  skip the need of creating everything out of rectangles and borders.
*
*/
PopupWindow {
    id: root

    property int menuWidth: 0
    property int popupWidth: 600
    property int screenHeight: 0
    property var currentApps: []
    property var closeCallback: function () {}

    // Once again, I must mention that these values are confusing but since I want to
    // capture focus immediately when the app launcher is opened, without the user having
    // to move their mouse cursor to it; the mess is necessary.
    anchor.window: taskbar
    anchor.rect.x: Screen.width / 2 - menuWidth / 2
    anchor.rect.y: parentWindow.implicitHeight
    implicitWidth: taskbar.width
    implicitHeight: screenHeight - parentWindow.implicitHeight - 4
    color: "transparent"

    // This is quite hacky, the reason this exists is so the search bar gains immediate focus
    // when you open the AppLauncher.
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.closeCallback();
        }
    }
    Rectangle {
        id: frame
        opacity: 0
        //anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: 350
        implicitWidth: root.popupWidth
        color: Config.colors.base
        layer.enabled: true

        property int topOffset: 20

        PopupWindowFrame {
            id: startMenuFrame
            windowTitle: "Search"
            windowTitleIcon: "\ue8b6"
            windowTitleDecorationWidth: 190
            Item {
                id: content
                anchors.fill: startMenuFrame
                anchors.margins: 8
                anchors.topMargin: frame.topOffset + 20
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    Rectangle {
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        implicitHeight: 40
                        color: Config.colors.highlight
                        border.color: Config.colors.outline
                        border.width: 1
                        clip: true
                        TextField {
                            id: searchInput
                            width: parent.width
                            anchors.centerIn: parent
                            text: ""
                            font.pixelSize: 16
                            font.family: fontMonaco.name
                            color: Config.colors.text
                            selectionColor: Config.colors.shadow
                            padding: 2
                            selectByMouse: true
                            cursorVisible: false
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            focus: true

                            background: Rectangle {
                                color: "transparent"
                            }

                            Keys.onEscapePressed: {
                                root.closeCallback();
                            }

                            Component.onCompleted: {
                                searchInput.forceActiveFocus();
                            }
                            onAccepted: {
                                if (root.currentApps.length == 1) {
                                    root.currentApps[0].execute();
                                    root.closeCallback();
                                }
                            }
                            onTextChanged: {
                                root.currentApps = Utils.AppSearch.fuzzyQuery(searchInput.text);
                                //console.log(Utils.AppSearch.fuzzyQuery(searchInput.text)[0].name);
                            }
                        }
                        Rectangle {
                            implicitHeight: 40
                            implicitWidth: 40
                            Layout.alignment: Qt.AlignLeft
                            color: Config.colors.base
                            border.color: Config.colors.outline
                            border.width: 1
                            Text {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors.fill: parent
                                font.family: iconFont.name
                                font.pixelSize: 24
                                text: "\ue8b6"
                            }
                        }
                    }
                    Rectangle {
                        implicitWidth: parent.width
                        implicitHeight: parent.height - 60
                        color: "transparent"
                        border.color: Config.colors.outline
                        border.width: 1
                        clip: true

                        ListView {
                            id: appsView
                            model: root.currentApps

                            anchors.fill: parent
                            anchors.margins: 6
                            anchors.bottomMargin: 1

                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.DragOverBounds
                            maximumFlickVelocity: 3500
                            clip: true

                            spacing: 8

                            delegate: Item {
                                width: parent.width
                                height: 40
                                Button {
                                    width: parent.width
                                    height: 40
                                    opacity: mouse.hovered ? 0.75 : 1
                                    background: Rectangle {
                                        anchors.fill: parent
                                        color: parent.pressed ? Config.colors.shadow : Config.colors.highlight
                                        border.width: 1
                                    }
                                    onReleased: {
                                        modelData.execute();
                                        root.closeCallback();
                                    }
                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0
                                        property var iconPath: Utils.AppSearch.getIcon(modelData.icon)
                                        Image {
                                            Layout.leftMargin: 8
                                            asynchronous: true
                                            Layout.maximumWidth: 24
                                            Layout.maximumHeight: 24
                                            antialiasing: true
                                            source: parent.iconPath
                                        }
                                        Text {
                                            Layout.fillWidth: true
                                            Layout.leftMargin: 8
                                            Layout.alignment: Qt.AlignLeft
                                            text: modelData.name
                                        }
                                    }
                                    HoverHandler {
                                        id: mouse
                                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }

                            ScrollIndicator.horizontal: ScrollIndicator {
                                active: appsView.moving
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

    function openAppLauncher() {
        root.visible = true;
        root.currentApps = Utils.AppSearch.fuzzyQuery("A");
        searchInput.text = "";
        openAnimation.start();
    }

    function closeAppLauncher() {
        closeAnimation.start();
    }
}
