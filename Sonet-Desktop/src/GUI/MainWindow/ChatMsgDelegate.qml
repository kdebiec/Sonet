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

Component{
    Item{
        width: parent.width
        height: view.height + dp(15)

        View{
            id: view
            height: textMsg.implicitHeight + dp(12)
            anchors.right: model.incoming === false ? parent.right : undefined
            anchors.left: model.incoming === false ?  undefined : parent.left
            anchors.rightMargin: parent.width*0.03
            anchors.leftMargin: parent.width*0.03
            width: (model.msg.length>45) ? (parent.width*0.8) :  textMsg.implicitWidth + dp(20)
            backgroundColor: model.incoming === false ? Theme.primaryColor : "white"
            elevation: 1
            radius: 10

            TextEdit {
                id: textMsg
                text: model.msg
                anchors.top: parent.top
                anchors.topMargin: dp(6)
                anchors.left: parent.left
                anchors.right: parent.right
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                color: model.incoming === false ? "white" : Theme.light.textColor
                readOnly: true
                selectByMouse: true
                selectionColor: Theme.accentColor

                horizontalAlignment: TextEdit.AlignHCenter

                font {
                    family: "Roboto"
                    pixelSize: dp(13)
                }
            }
        }
    }
}
