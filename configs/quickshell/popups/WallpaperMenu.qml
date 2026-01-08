import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Qt.labs.folderlistmodel
import ".."

PopupWindow {
    id: root
    property int menuWidth: 0
    anchor.window: taskbar
    anchor.rect.x: menuWidth
    anchor.rect.y: parentWindow.implicitHeight
    implicitWidth: 700
    implicitHeight: 260
    color: "transparent"
    property bool isApplying: false

    Rectangle {
        id: frame
        opacity: 0
        anchors.fill: parent
        color: Config.colors.base
        layer.enabled: true
        property int topOffset: 20

        PopupWindowFrame {
            id: menuFrame
            windowTitle: "Wallpapers"
            windowTitleIcon: "image"
            windowTitleDecorationWidth: 260

            Item {
                id: content
                anchors.fill: menuFrame
                anchors.margins: 8
                anchors.topMargin: frame.topOffset + 20
                clip: true

                ColumnLayout {
                    spacing: 6

                    // === Thumbnails scroller ===
                    Item {
                        implicitHeight: 150
                        implicitWidth: menuFrame.width

                        FolderListModel {
                            id: dirModel
                            folder: "file://" + Config.settings.wallpaperDir
                            nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
                            showDirs: false
                            showDotAndDotDot: false
                        }

                        Flickable {
                            id: flick
                            anchors.fill: parent
                            contentWidth: row.width + 10
                            contentHeight: row.height
                            flickableDirection: Flickable.HorizontalFlick
                            boundsBehavior: Flickable.DragOverBounds
                            maximumFlickVelocity: 3500

                            RowLayout {
                                id: row
                                spacing: 10
                                height: parent.height

                                Repeater {
                                    model: dirModel
                                    delegate: Button {
                                        implicitWidth: 200
                                        implicitHeight: 120
                                        opacity: pressed ? 0.7 : 1
                                        clip: true

                                        property url fileUrl: dirModel.folder + "/" + fileName
                                        property string filePath: fileUrl.toString().replace("file://","")

                                        background: Rectangle {
                                            anchors.fill: parent
                                            color: hover.hovered ? Config.colors.shadow : Config.colors.base
                                            border.width: 1
                                            border.color: Config.colors.outline
                                        }

                                        contentItem: Item {
                                            anchors.fill: parent
                                            Image {
                                                anchors.fill: parent
                                                anchors.margins: 6
                                                fillMode: Image.PreserveAspectCrop
                                                source: fileUrl
                                                cache: true
                                                smooth: true
                                            }
                                        }

                                        onClicked: {
                                            if (root.isApplying) return;
                                            root.isApplying = true;

                                            Config.settings.currentWallpaper = filePath;
                                            applyWallpaper(filePath)

                                            Qt.callLater(() => { root.isApplying = false; });
                                        }

                                        HoverHandler {
                                            id: hover
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
                                var delta = wheel.angleDelta.y * 0.25;
                                flick.contentX = Math.max(0, Math.min(flick.contentWidth - flick.width, flick.contentX - delta));
                            }
                        }
                    }

                    // === Info row ===
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6
                        Text { font.family: fontCharcoal.name; font.pixelSize: 13; text: "Current Wallpaper:" }
                        Text {
                            font.family: fontMonaco.name
                            font.pixelSize: 13
                            text: Config.settings.currentWallpaper === "" ? "(none)" : Config.settings.currentWallpaper.split("/").pop()
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }

        OpacityAnimator { id: openAnim;  target: frame; from: 0; to: 1; duration: 140; easing.type: Easing.OutCubic }
        OpacityAnimator { id: closeAnim; target: frame; from: 1; to: 0; duration: 80; easing.type: Easing.InOutQuad; onFinished: root.visible = false }
    }

    Process { id: proc }
    function startCmd(argv) {
        if (proc.hasOwnProperty("command")) {
            proc.command = argv;
        } else {
            proc.program = argv[0];
            proc.args = argv.slice(1);
        }
        if (typeof proc.startDetached === "function") {
            proc.startDetached();
        } else if (typeof proc.run === "function") {
            proc.run();
        } else if (typeof proc.start === "function") {
            proc.start();
        } else {
            proc.running = true;
        }
    }

    function applyWithHyprpaper(filePath) {
        const sh = `
        set -e
        cfg="$HOME/.config/hypr/hyprpaper.conf"
        wp="$1"
        mkdir -p "$(dirname "$cfg")"
        printf 'preload = %s\n' "$wp" > "$cfg"
        printf 'wallpaper = ,%s\n' "$wp" >> "$cfg"
        pkill -x hyprpaper 2>/dev/null || true
        for i in $(seq 1 40); do pgrep -x hyprpaper >/dev/null || break; sleep 0.05; done
        nohup hyprpaper >/dev/null 2>&1 & disown
        `;
        startCmd(["/bin/bash", "-lc", sh, "qs", filePath]);
    }

    function applyWithScript(filePath) {
        const sp = Config.settings.wallpaperScriptPath;
        if (!sp || sp.trim() === "") return false;
        startCmd(["/bin/bash", sp, filePath]);
        return true;
    }

    function applyWallpaper(filePath) {
        console.log("applyWallpaper:", filePath);

        // 1) Prefer user script
        if (applyWithScript(filePath)) {
            console.log("used script:", Config.settings.wallpaperScriptPath);
            return;
        }

        // 2) Fallback: hyprpaper
        console.log("no script; using hyprpaper");
        applyWithHyprpaper(filePath);
    }

    function openWallpaperMenu() {
        root.visible = true;
        openAnim.start();
    }

    function closeWallpaperMenu() { 
        closeAnim.start();
        Config.currentPopup = Config.SystemPopup.None;
    }
}




