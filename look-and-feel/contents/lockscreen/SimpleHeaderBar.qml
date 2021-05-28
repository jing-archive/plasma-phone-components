/*
 *  Copyright 2019 Marco Martin <mart@kde.org>
 *            2020 Devin Lin <espidev@gmail.com>
 *            2021 Rui Wang <wangrui@jingos.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.workspace.components 2.0 as PW
import org.kde.plasma.private.digitalclock 1.0 as DC
import org.kde.plasma.private.mobileshell 1.0 as MobileShell
import "indicators" as Indicators

// a simple version of the task panel
// in the future, it should share components with the existing task panel
PlasmaCore.ColorScope {
    id:icons
    colorGroup: PlasmaCore.Theme.ComplementaryColorGroup
    
    layer.enabled: true
    layer.effect: DropShadow {
        anchors.fill: icons
        visible: MobileShell.HomeScreenControls.homeScreenVisible
        cached: true
        horizontalOffset: 0
        verticalOffset: 1
        radius: 4.0
        samples: 17
        color: Qt.rgba(0,0,0,0.8)
        source: icons
    }
    
    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 60 * 1000
    }
    
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 1.0
                color: "transparent"
            }
            GradientStop {
                position: 0.0
                color: Qt.rgba(0, 0, 0, 0.1)
            }
        }
    }
    
    // Loader {
    //     id: strengthLoader
    //     height: parent.height
    //     width: item ? item.width : 0
    //     source: Qt.resolvedUrl("indicators/SignalStrength.qml")
    // }

    PlasmaComponents.Label {
        id: clock
        anchors.left: parent.left
        anchors.leftMargin: height / 2
        height: parent.height
        text: getLocalTimeString()//Qt.formatTime(timeSource.data.Local.DateTime, is24HourTime ? "hh:mm" : "hh:mm AP")
        color: PlasmaCore.ColorScope.textColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        font.pointSize: 9// height - height / 3
    }

    RowLayout {
        id: appletIconsRow
        anchors {
            bottom: parent.bottom
            right: simpleIndicatorsLayout.left
        }
        height: parent.height
    }

    RowLayout {
        id: simpleIndicatorsLayout
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: units.smallSpacing
        }
//        Indicators.Bluetooth {}
//        Indicators.Wifi {}
//        Indicators.Volume {}
        Indicators.Battery {}
    }

    RowLayout{
        id:wirelessIndicatorsLayout

        anchors.bottom: parent.bottom
        anchors.left: clock.right
        anchors.leftMargin: 5//units.smallSpacing

        height: parent.height

        Indicators.Wifi {}
        Indicators.Bluetooth {}

    }

    DC.TimeZoneFilterProxy{
        id:timezoneProxy
    }


    function getLocalTimeString(){
        var timeStr = String(timeSource.data["Local"]["DateTime"]);
        var isChinaLocal = (timeStr.indexOf("GMT+0800") != -1)
        timeStr = Qt.formatTime(timeSource.data["Local"]["DateTime"], timezoneProxy.isSystem24HourFormat ? "h:mm" : "h:mm AP");
        if(isChinaLocal){
            if(timeStr.search("AM") != -1)
                timeStr = timeStr.replace("AM","上午");
            if(timeStr.search("PM") != -1)
                timeStr = timeStr.replace("PM","下午");
        }
        else{
            if(timeStr.search("上午") != -1)
                timeStr = timeStr.replace("上午","AM");
            if(timeStr.search("下午") != -1)
                timeStr = timeStr.replace("下午","PM");
        }
        return timeStr;
    }
}
