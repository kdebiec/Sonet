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
import QtQuick.Layouts 1.1

import Material 0.3
import Material.Extras 0.1
import Material.ListItems 0.1 as ListItem

Rectangle
{
    id: main
    color: "#eeeeee"

    property bool borderless: false
    property bool attemptLogin: false

    width: dp(400)
    height: dp(470)

    state: "waiting_init"

    states:[
        State {
            name: "waiting_account_select"
            PropertyChanges { target: mask; state: "invisible"}
            StateChangeScript {script: {runStateHelper.setRunState("waiting_account_select")}}
        },
        State {
            name: "running_ok"
            StateChangeScript {script: {runStateHelper.setRunState("running_ok"); Qt.quit()}}
        },
        State {
            name: "running_ok_no_full_control"
            StateChangeScript {script: {runStateHelper.setRunState("running_ok_no_full_control"); Qt.quit()}}
        },
        State {
            name: "fatal_error"
            StateChangeScript {script: {runStateHelper.setRunState("fatal_error"); Qt.quit()}}
        },
        State {
            name: "waiting_startup"
            PropertyChanges { target: mask; state: "visible"}
            StateChangeScript {script: {runStateHelper.setRunState("waiting_startup")}}
        },
        State {
            name: "waiting_init"
            PropertyChanges { target: mask; state: "visible"}
            StateChangeScript {script: {runStateHelper.setRunState("waiting_init")}}
        }
    ]

    AppTheme {
        id: __theme

        primaryColor: Palette.colors["green"]["500"]
        accentColor: Palette.colors["deepOrange"]["500"]
        tabHighlightColor: "white"
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.3)
        z: 10

        states:[
            State {
                name: "visible"
                PropertyChanges { target: mask; enabled: true; opacity: 1 }
            },
            State {
                name: "invisible"
                PropertyChanges { target: mask; enabled: false; opacity: 0}
            }
        ]

        transitions: [
            Transition {
                from: "visible"; to: "invisible"
                NumberAnimation { properties: "opacity"; from: 1; to: 0; easing.type: Easing.InOutQuad; duration: MaterialAnimation.pageTransitionDuration*2 }
            },
            Transition {
                from: "invisible"; to: "visible"
                NumberAnimation { properties: "opacity"; from: 0; to: 1; easing.type: Easing.InOutQuad; duration: MaterialAnimation.pageTransitionDuration*2 }
            }
        ]

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {}
            onPressed: {}
        }
        View{
            anchors.centerIn: parent
            height: parent.height*0.3
            width: parent.width
            elevation: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: dp(3)
                text: "PLEASE WAIT"
                color: Qt.rgba(0,0,0,0.85)
                font.family: "Roboto"
                font.pixelSize: 18
            }

            ProgressCircle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                anchors.topMargin: dp(3)
                color: Theme.accentColor
                width: dp(27)
                height: dp(27)
                dashThickness: dp(4)
            }
        }
    }

    Component.onCompleted: {
        getRunState()
        getLocations()
    }

    function getRunState() { var jsonData = {callback_name: "bordered_control_runstate"}; rsApi.request("/control/runstate/", JSON.stringify(jsonData), function(par) { main.state = String(JSON.parse(par.response).data.runstate); }) }
    function getLocations() { var jsonData = {callback_name: "bordered_control_locations"}; rsApi.request("/control/locations/", JSON.stringify(jsonData), function(par) { locationsModel.json = par.response; }) }

    Connections{
        target: rsApi
        onResponseReceived: {
            var jsonData = JSON.parse(msg)

            if(jsonData)
            {
                if(jsonData.data)
                {
                    if (jsonData.data.key_name)
                    {
                        if(jsonData.data.want_password)
                        {
                            // if Server requested password
                            var jsonPass = { password: passwordLogin.text }
                            rsApi.request("/control/password/", JSON.stringify(jsonPass))
                            main.attemptLogin = false
                        }
                    }
                }
            }
        }
    }

    JSONListModel
    {
        id: locationsModel
        query: "$.data[*]"
    }

    Image{
        id: bgImage
        anchors.fill: parent
        source: "/colorful.jpg"
        fillMode: Image.PreserveAspectCrop

        Component.onCompleted: {
            if(borderless)
            {
                Qt.createQmlObject('
                import QtQuick 2.5
                import QtQuick.Layouts 1.1

                import Material 0.3
                import Material.Extras 0.1

                Row {
                    anchors {
                        top: parent.top
                        right: parent.right
                        rightMargin: dp(parent.width*0.05)
                    }

                    spacing: 5 * Units.dp


                    MouseArea{
                        width: dp(24)
                        height: closeButton.height - dp(7)
                        anchors.top: parent.top
                        anchors.topMargin: dp(10)
                        hoverEnabled: true
                        z:1

                        onEntered: mini.color = Theme.accentColor
                        onExited: mini.color = "white"
                        onClicked: qMainPanel.pushButtonMinimizeClicked()


                        Rectangle{
                            id: mini
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: dp(3)
                            color: "white"
                        }
                    }

                    IconButton {
                        id: closeButton
                        anchors.top: parent.top
                        anchors.topMargin: dp(10)
                        iconSource: "/navigation_close.png"
                        inkHeight: closeButton.height
                        inkWidth: closeButton.width
                        size: dp(35)
                        color: "white"
                        onEntered: closeButton.color = Theme.accentColor
                        onExited: closeButton.color = "white"
                        onClicked: Qt.quit()
                    }
                }', main);
            }
        }

        View{
            id: mainview
            y: parent.height*0.42
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*0.88
            height: parent.height*0.5
            elevation: 4

            Column {
                id: column

                anchors {
                    fill: parent
                    topMargin: dp(parent.height*0.08)
                    leftMargin: parent.width*0.05
                    rightMargin: parent.width*0.07
                    bottomMargin: dp(parent.height*0.28)
                }

                ListItem.Standard {
                    margins: 0
                    spacing: dp(5)
                    action: Icon {
                        anchors.centerIn: parent
                        name: "awesome/user"
                    }

                    content: TextField {
                        id: usernameLogin
                        anchors.centerIn: parent
                        width: parent.width
                        color: Theme.primaryColor
                        property alias selectedIndex: listView.currentIndex

                        readOnly: true

                        text: locationsModel.count > 0 ? listView.currentItem.text : ""
                        placeholderText: "Username"

                        IconButton {
                            id: overflowButton2
                            anchors.right: parent.right
                            anchors.rightMargin: dp(8)
                            width: parent.height
                            height: parent.height

                            iconName: "awesome/caret_down"
                            color: Theme.light.textColor
                            onClicked: overflowMenu2.open(overflowButton2, dp(7), 25 * Units.dp);

                            onEntered: color = Theme.primaryColor
                            onExited: color = Theme.light.textColor
                        }

                        Dropdown {
                            id: overflowMenu2
                            objectName: "overflowMenu2"
                            overlayLayer: "dialogOverlayLayer"
                            width: 250 * Units.dp
                            height: Math.min(10 * 48 * Units.dp + 16 * Units.dp, locationsModel.count * 40 * Units.dp)
                            enabled: true

                            ListView{
                                id: listView
                                height: count > 0 ? contentHeight : 0
                                width: parent.width
                                model: locationsModel.model

                                delegate: ListItem.Standard {
                                            height: 40
                                            text: model.name
                                            onClicked: {
                                                listView.currentIndex = index
                                                overflowMenu2.close()
                                            }
                                          }
                            }
                        }
                    }
                }

                ListItem.Standard {
                    margins: 0
                    spacing: dp(5)
                    action: Icon {
                        anchors.centerIn: parent
                        name: "awesome/unlock_alt"
                    }

                    content: TextField {
                        id: passwordLogin
                        anchors.centerIn: parent
                        width: parent.width
                        color: Theme.primaryColor

                        echoMode: TextInput.Password
                        placeholderText: "Password"

                        onAccepted: {
                            if(passwordLogin.text.length >= 3)
                            {
                                rsApi.request("/control/login/", JSON.stringify({id: locationsModel.model.get(usernameLogin.selectedIndex).id}))
                                main.attemptLogin = true
                            }
                        }
                    }
                }

                Item{
                    height: dp(1)
                    width: parent.width
                    RowLayout{
                        y: -20
                        anchors.left: parent.left
                        anchors.leftMargin: dp(29)
                        spacing: -10

                        CheckBox {
                            id: checkBox
                            darkBackground: false
                            enabled: false
                        }
                        Label {
                            text: "Remember me"
                            color: Theme.light.textColor

                            MouseArea{
                                anchors.fill: parent
                                enabled: false
                                onClicked: {
                                  checkBox.checked = !checkBox.checked
                                  checkBox.clicked()
                                }
                            }
                        }
                    }
                }

                Item{
                    height: dp(65)
                    width: parent.width
                    Button {
                        text: "Login"
                        textColor: Theme.primaryColor
                        size: dp(23)
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            if(passwordLogin.text.length >= 3)
                            {
                                rsApi.request("/control/login/", JSON.stringify({id: locationsModel.model.get(usernameLogin.selectedIndex).id}))
                                main.attemptLogin = true
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: buttonCreate
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor

                state: "button"

                transitions:[
                    Transition {

                        ParallelAnimation {
                            NumberAnimation { target: buttonCreate; property: "anchors.bottomMargin"; duration: 120 }
                            NumberAnimation { target: buttonCreate; property: "height"; duration: 120 }
                            NumberAnimation { target: buttonCreate; property: "width"; duration: 120 }
                            NumberAnimation { target: text; property: "visible"; duration: 50 }
                        }
                    }
                ]

                states: [
                    State {
                        name: "button";
                        PropertyChanges { target: buttonCreate;  width: mainview.width; height: parent.height*0.18}
                        PropertyChanges { target: text; visible: true}
                        PropertyChanges { target: switchButton; visible: false}
                        PropertyChanges { target: overflowButton; visible: false}
                        PropertyChanges { target: column2; visible: false}
                        PropertyChanges { target: buttonCreate2; visible: false}
                    },
                    State {
                        name: "reg";
                        PropertyChanges { target: buttonCreate; anchors.bottomMargin: 0; height: mainview.height; width: mainview.width;}
                        PropertyChanges { target: text; visible: false}
                        PropertyChanges { target: switchButton; visible: true}
                        PropertyChanges { target: overflowButton; visible: true}
                        PropertyChanges { target: column2; visible: true}
                        PropertyChanges { target: buttonCreate2; visible: true}
                    }
                ]

                Text{
                    id: text
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Create an account"
                    font.pixelSize: dp(20)
                    font.family: "Roboto"
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        buttonCreate.state = "reg"
                    }
                }

                IconButton {
                    id: overflowButton

                    anchors.top: parent.top
                    anchors.topMargin: dp(10)
                    anchors.right: parent.right
                    anchors.rightMargin: dp(parent.width*0.05)
                    iconName: "awesome/cog"
                    hoverAnimation: true
                    size: dp(25)
                    color: "white"
                    onClicked: overflowMenu.open(overflowButton, -25 * Units.dp, 25 * Units.dp);
                }

                IconButton {
                    id: switchButton
                    anchors.top: parent.top
                    anchors.topMargin: dp(10)
                    anchors.left: parent.left
                    anchors.leftMargin: dp(parent.width*0.05)
                    iconName: "awesome/chevron_left"
                    size: dp(25)
                    color: "white"
                    onClicked: buttonCreate.state = "button"
                }

                Dropdown {
                    id: overflowMenu
                    objectName: "overflowMenu"
                    overlayLayer: "dialogOverlayLayer"
                    width: 250 * Units.dp
                    height: columnView.height + 16 * Units.dp
                    enabled: true

                    Column {
                        id: columnView
                        width: parent.width*0.8
                        anchors.centerIn: parent

                        Item{
                            width: parent.width
                            height: dp(10)
                        }

                        TextField {
                            id: node
                            width: parent.width
                            placeholderText: "Node name"
                            floatingLabel: true
                            text: "Desktop"
                        }
                    }
                }

                Column {
                    id: column2

                    anchors {
                        fill: parent
                        topMargin: dp(parent.height*0.08)
                        leftMargin: parent.width*0.05
                        rightMargin: parent.width*0.05
                        bottomMargin: dp(parent.height*0.28)
                    }


                    Item{
                        width: 1
                        height: parent.height*0.15
                    }

                    ListItem.Standard {
                        margins: 0
                        spacing: dp(5)
                        action: Icon {
                            anchors.centerIn: parent
                            name: "awesome/user"
                            color: "white"
                        }

                        content: TextField {
                            id: username
                            anchors.centerIn: parent
                            width: parent.width
                            color: "white"
                            textColor: "white"
                            borderColor: Qt.rgba(255,255,255,0.5)
                            placeholderTextColor: Qt.rgba(255,255,255,0.65)

                            focus: true
                            placeholderText: "Username"
                        }
                    }

                    ListItem.Standard {
                        margins: 0
                        spacing: dp(5)
                        action: Icon {
                            anchors.centerIn: parent
                            name: "awesome/unlock_alt"
                            color: "white"
                        }

                        content: TextField {
                            id: password
                            anchors.centerIn: parent
                            width: parent.width
                            color: "white"
                            textColor: "white"
                            borderColor: Qt.rgba(255,255,255,0.5)
                            placeholderTextColor: Qt.rgba(255,255,255,0.65)

                            echoMode: TextInput.Password
                            placeholderText: "Password"
                        }
                    }
                    ListItem.Standard {
                        margins: 0
                        spacing: dp(5)
                        action: Icon {
                            anchors.centerIn: parent
                            name: "awesome/unlock_alt"
                            color: "white"
                        }

                        content: TextField {
                            id: password2
                            anchors.centerIn: parent
                            width: parent.width
                            color: "white"
                            textColor: "white"
                            borderColor: Qt.rgba(255,255,255,0.5)
                            placeholderTextColor: Qt.rgba(255,255,255,0.65)

                            echoMode: TextInput.Password
                            placeholderText: "Repeat password"
                        }
                    }
                }

                Button {
                    id: buttonCreate2
                    text: "Create"
                    textColor: "white"
                    size: dp(17)
                    backgroundColor: Theme.primaryColor
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: mainview.height*0.08; width: mainview.width*0.9; height: parent.height*0.12

                    onClicked: {
                        if(password.text === password2.text)
                        {
                            var jsonData = { pgp_name: username.text, ssl_name: node.text, pgp_password: password.text }
                            rsApi.request("/control/create_location/", JSON.stringify(jsonData))
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: attemptTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            getRunState()
            if (main.attemptLogin)
                rsApi.request("/control/password/", "")
        }
    }

    OverlayLayer {
        id: dialogOverlayLayer
        objectName: "dialogOverlayLayer"
        z: 10
    }

    OverlayLayer {
        id: overlayLayer
    }

    // Units
    function dp(dp) {
        return dp * Units.dp
    }

    function gu(gu) {
        return units.gu(gu)
    }

    UnitsHelper {
        id: units
    }
}
