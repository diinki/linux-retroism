pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Config.settings.militaryTimeClockFormat
            ? Qt.formatDateTime(clock.date, " MMM d yyyy | HH:mm")
            : Qt.formatDateTime(clock.date, " MMM d yyyy | h:mm AP");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
