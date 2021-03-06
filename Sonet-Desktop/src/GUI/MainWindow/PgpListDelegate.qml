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
import QtQuick.Layouts 1.3

import Material 0.3
import Material.Extras 0.1 as Circle
import Material.ListItems 0.1 as ListItem

Component{
    id: notificationDelegate

    Item{
        id: pgpBaseItem
        property string msg: model.custom_state_string
        property string state_string: model.state_string
        property color statuscolor: state_string === "online"   ? "#4caf50" :   // green
                                    state_string === "busy"     ? "#FF5722" :   // red
                                    state_string === "away"     ? "#FFEB3B" :   // yellow
                                                                  "#9E9E9E"     // grey
        property string pgp: model.pgp_id

        clip: true
        width: parent.width
        height: dp(50)

        state: "hide_loc"
        states:[
            State {
                name: "hide_loc";
                PropertyChanges { target: pgpBaseItem; height: dp(50) }
            },
            State {
                name: "show_loc";
                PropertyChanges { target: pgpBaseItem; height: dp(50)+dp(locationsModel.count*50) }
            }
        ]

        transitions: [
            Transition {
                from: "hide_loc"
                to: "show_loc"

                NumberAnimation {
                    target: pgpBaseItem
                    property: "height"
                    duration: MaterialAnimation.pageTransitionDuration/2
                    easing.type: Easing.InOutQuad
                }
            },

            Transition {
                from: "show_loc"
                to: "hide_loc"

                NumberAnimation {
                    target: pgpBaseItem
                    property: "height"
                    duration: MaterialAnimation.pageTransitionDuration/2
                    easing.type: Easing.InOutQuad
                }
            }
        ]

        JSONListModel{
            id: locationsModel
            json: pgpIdModel.json
            query: "$.data[?(@.pgp_id=='"+pgp_id+"')].locations[*]"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(pgpBaseItem.state == "show_loc"){
                    pgpBaseItem.state = "hide_loc"
                    peerBoxIcon.state = "rotated"
                }
                else if(pgpBaseItem.state == "hide_loc"){
                    pgpBaseItem.state = "show_loc"
                    peerBoxIcon.state = "nonrotated"
                }
            }
        }

        Rectangle{
            id: friendroot
            property int unread_msgs: 0
            anchors.top: parent.top
            height: dp(50)
            clip: true
            width: parent.width

            states:[
                State {
                    name: "hidden";
                    PropertyChanges { target: friendroot; color: "#ffffff" }
                },
                State {
                    name: "entered";
                    PropertyChanges { target: friendroot; color: Qt.rgba(0,0,0,0.03) }
                }
            ]

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                hoverEnabled: true
                onEntered: friendroot.state = "entered"
                onExited: friendroot.state = "hidden"
                onClicked: overflowMenu.open(friendroot, mouse.x, mouse.y);

                states:[
                    State {
                        name: "name"; when: msg === ""
                        PropertyChanges { target: name; height: friendroot.height; verticalAlignment: Text.AlignVCenter; }
                    },
                    State {
                        name: "smsg"; when: msg != ""
                        PropertyChanges { target: name; height: friendroot.height/2; verticalAlignment: Text.AlignBottom; }
                    }
                ]

                Dropdown {
                    id: overflowMenu
                    objectName: "overflowMenu"
                    overlayLayer: "dialogOverlayLayer"
                    width: 200 * Units.dp
                    height: dp(1*30)
                    enabled: true
                    anchor: Item.TopLeft
                    durationSlow: 200
                    durationFast: 100

                    Column{
                        anchors.fill: parent

                        ListItem.Standard {
                            height: dp(30)
                            text: "Remove"
                            itemLabel.style: "menu"
                            onClicked: {
                                overflowMenu.close()
                                //friendList.removePgpContact(rspgpid);
                            }
                        }
                    }
                }

                Icon {
                    id: peerBoxIcon

                    anchors.verticalCenter: parent.verticalCenter
                    x: 10
                    width: 40
                    height: 40
                    state: "rotated"

                    states: [
                        State {
                            name: "nonrotated";
                            PropertyChanges {
                                target: peerBoxIcon
                                rotation: 0
                            }
                        },
                        State {
                            name: "rotated";
                            PropertyChanges {
                                target: peerBoxIcon
                                rotation: -90
                            }
                        }
                    ]

                    name: "awesome/chevron_down"
                    color: "#9E9E9E"

                    size: 15 * Units.dp

                    Behavior on rotation {
                        NumberAnimation { duration: MaterialAnimation.pageTransitionDuration/2 }
                    }
                }

                Item{
                    id: text

                    x: 60
                    width: 151
                    height: parent.height

                    Text {
                        id: name
                        height: parent.height
                        text: model.name
                        color: Theme.light.textColor
                        font.family: "Roboto"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 14
                    }
                    Text {
                        id: smsg
                        y: parent.height/2
                        height: parent.height/2
                        color: statuscolor
                        text: msg
                        font.family: "Roboto"
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 12
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: friendroot.unread_msgs > 0 ? 10 : 15
                    width: friendroot.unread_msgs > 0 ? 20 : 10
                    height: friendroot.unread_msgs > 0 ? 20 : 10
                    radius: width/2
                    color: statuscolor

                    Text{
                        anchors.fill: parent
                        text: friendroot.unread_msgs
                        color: "white"
                        font.family: "Roboto"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        visible: friendroot.unread_msgs > 0 ? true : false
                    }
                }
            }
        }

        ListView {
            id: listView
            anchors.top: friendroot.bottom
            anchors.bottom: pgpBaseItem.bottom
            anchors.left: pgpBaseItem.left
            anchors.right: pgpBaseItem.right

            clip: true

            model: locationsModel.model
            delegate: PeerListDelegate{}
        }
    }
}
