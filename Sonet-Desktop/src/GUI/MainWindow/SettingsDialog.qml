/****************************************************************
 *  This file is part of Sonet.
 *  Sonet is distributed under the following license:
 *
 *  Copyright (C) 2017, Konrad Dębiec
 *
 *  Sonet is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 3
 *  of the License, or (at your option) any later version.
 *
 *  Sonet is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA  02110-1301, USA.
 ****************************************************************/

import QtQuick 2.5
import QtQuick.Controls 1.4 as QtControls

import Material 0.3
import Material.Extras 0.1
import Material.ListItems 0.1 as ListItem

Dialog {
    id: scrollingDialog

    property bool advmode: main.advmode
    property bool flickablemode: main.flickablemode

    positiveButtonText: "Cancel"
    negativeButtonText: "Apply"
    contentMargins: dp(8)

    positiveButtonSize: 13
    negativeButtonSize: 13

    onRejected:{
        var jsonData = {
            advanced_mode: advmode,
        }
        rsApi.request("/settings/set_advanced_mode/", JSON.stringify(jsonData))

        var jsonData2 = {
            flickable_grid_mode: flickablemode,
        }
        rsApi.request("/settings/set_flickable_grid_mode/", JSON.stringify(jsonData2))

        main.advmode = scrollingDialog.advmode
        main.flickablemode = scrollingDialog.flickablemode
    }

    onOpened: {
        scrollingDialog.advmode = main.advmode
        scrollingDialog.flickablemode = main.flickablemode
    }

    Component.onCompleted:
    {
        getAdvancedMode()
        getFlickableGridMode()
    }

    function getAdvancedMode() { var jsonData = {callback_name: "settingsdialog_get_advanced_mode"}; rsApi.request("/settings/get_advanced_mode/", JSON.stringify(jsonData), function(par) { scrollingDialog.advmode = Boolean(JSON.parse(par.response).data.advanced_mode); })}

    function getFlickableGridMode() { var jsonData = {callback_name: "settingsdialog_get_flickable_grid_mode"}; rsApi.request("/settings/get_flickable_grid_mode/", JSON.stringify(jsonData), function(par) { scrollingDialog.flickablemode = Boolean(JSON.parse(par.response).data.flickable_grid_mode); })}

    // Should works as follow
    //positiveButtonText: "Apply"
    //negativeButtonText: "Cancel"

    Label {
        id: titleLabel

        anchors.left: parent.left
        anchors.leftMargin: dp(15)
        verticalAlignment: Text.AlignVCenter
        height: dp(50)
        wrapMode: Text.Wrap
        text: "Settings"
        style: "title"
        color: Theme.accentColor
    }

    Item{
        width: main.width < dp(900) ? main.width - dp(100) : dp(600)
        height: main.width < dp(450) ? main.width - dp(100) : dp(300)

        Column{
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width/4

            ListItem.Standard {
                text: "General"

                selected: tabView.currentIndex === 0
                onClicked: tabView.currentIndex = 0
            }
        }

        QtControls.TabView {
            id: tabView
            frameVisible: false
            tabsVisible: false
            anchors.leftMargin: parent.width/4
            anchors.fill: parent
            QtControls.Tab {
                title: "General"
                Column {
                    anchors.fill: parent

                    ListItem.Subtitled {
                        text: "Start Sonet on system start"
                        height: dp(55)
                        interactive: false
                        secondaryItem: Switch {
                            id: switch2
                            anchors.verticalCenter: parent.verticalCenter
                            enabled: false
                        }
                    }

                    ListItem.Subtitled {
                        text: "Scrollable desktop"
                        height: dp(55)
                        secondaryItem: Switch {
                            id: switch4
                            anchors.verticalCenter: parent.verticalCenter
                            checked: scrollingDialog.flickablemode

                            onClicked: {
                                scrollingDialog.flickablemode = switch4.checked
                                switch4.checked = Qt.binding(function() {return scrollingDialog.flickablemode})
                            }
                        }

                        onClicked: {
                            switch4.checked = !switch4.checked
                            scrollingDialog.flickablemode = switch4.checked
                            switch4.checked = Qt.binding(function() {return scrollingDialog.flickablemode})
                        }
                    }

                    ListItem.Subtitled {
                        text: "Advanced mode"
                        height: dp(55)
                        secondaryItem: Switch {
                            id: switch3
                            anchors.verticalCenter: parent.verticalCenter
                            checked: scrollingDialog.advmode

                            onClicked: {
                                scrollingDialog.advmode = switch3.checked
                                switch3.checked = Qt.binding(function() {return scrollingDialog.advmode})
                            }
                        }

                        onClicked: {
                            switch3.checked = !switch3.checked
                            scrollingDialog.advmode = switch3.checked
                            switch3.checked = Qt.binding(function() {return scrollingDialog.advmode})
                        }
                    }
                }
            }
        }
    }
}
