pragma Singleton

import Quickshell
import QtQuick

import Quickshell.Io

import Quickshell.Services.UPower

Singleton {
    id: root
    
    property bool isPortable: false

    readonly property string status: {
        (isPortable
            ? " " + (UPower.displayDevice.isPresent
	        ? (UPower.displayDevice.percentage == 1 && (!(UPower.onBattery))
                    ? "100% (Fully Charged"
		    : (UPower.displayDevice.percentage * 100).toFixed(0) + "% (" + (UPower.onBattery ? "Discharging" : "Charging"))
		: "(Not Present")
	    + ") |"
            : "")
        + Qt.formatDateTime(clock.date, " MMM d yyyy | hh:mm:ss");
    }

    Process {
        id: chassisProc
        command: ["hostnamectl", "chassis"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var type = data.trim()
                switch(type) {
                    case "laptop":
                    case "convertible":
                    case "tablet":
                    case "handset":
                    case "watch":       // you can never be certain that nobody wants your rice on a smartwatch
                        isPortable = true;
                }
            }
        }
        Component.onCompleted: running = true
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
