import QtQuick
import ".."

Text {
    text: StatusText.status
    color: Config.colors.text
    font.pixelSize: Config.settings.bar.fontSize
    font.family: fontMonaco.name
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
