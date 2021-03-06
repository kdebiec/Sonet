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
import Material 0.3

Rectangle{

    color: Palette.colors["grey"]["200"]

    // Frame:
        // Left edge
        MouseArea{
            id: leMA
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            width: 5
            hoverEnabled: enabled
            //preventStealing: true

            onEntered: cursor.changeCursor(Qt.SizeHorCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(mouse.x, 0, true, true);
            }
        }
        // Right edge
        MouseArea{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            width: 5
            hoverEnabled: enabled
            preventStealing: true

            onEntered: cursor.changeCursor(Qt.SizeHorCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(mouse.x, 0, false, false);
            }
        }
        // Top edge
        MouseArea{
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            height: 5
            hoverEnabled: enabled

            onEntered: cursor.changeCursor(Qt.SizeVerCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(0, mouse.y, true, true);
            }
        }
        // Bottom edge
        MouseArea{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            height: 5
            hoverEnabled: enabled

            onEntered: cursor.changeCursor(Qt.SizeVerCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(0, mouse.y, false, false);
            }
        }
        // Left-top corner
        MouseArea{
            anchors.top: parent.top
            anchors.left: parent.left
            height: 5
            width: 5
            hoverEnabled: enabled

            onEntered: cursor.changeCursor(Qt.SizeFDiagCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(mouse.x, mouse.y, true, true);
            }
        }
        // Right-top corner
        MouseArea{
            anchors.top: parent.top
            anchors.right: parent.right
            height: 5
            width: 5
            hoverEnabled: enabled

            onEntered: cursor.changeCursor(Qt.SizeBDiagCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(mouse.x, mouse.y, false, true);
            }
        }
        // Left-Bottom corner
        MouseArea{
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: 5
            width: 5
            hoverEnabled: enabled

            onEntered: cursor.changeCursor(Qt.SizeBDiagCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(mouse.x, mouse.y, true, false);
            }
        }
        // Right-Bottom corner
        MouseArea{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: 5
            width: 5
            hoverEnabled: enabled
            preventStealing: true

            onEntered: cursor.changeCursor(Qt.SizeFDiagCursor)
            onExited: cursor.changeCursor(Qt.ArrowCursor)

            MouseArea{
                anchors.fill: parent
                onPositionChanged: qMainPanel.resizeWin(mouse.x, mouse.y, false, false);
            }
        }

        MouseArea{
            anchors.fill: parent
            anchors.margins: 5
            acceptedButtons: Qt.LeftButton

            onPressed: qMainPanel.mouseLPressed()
            onDoubleClicked: qMainPanel.pushButtonMaximizeClicked()
        }

    MainGUI{
        anchors.fill: parent
        borderless: true

    }
}
