/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import QtGraphicalEffects 1.12


Rectangle {
    id: root;
    visible: true;
    anchors.top: parent.top;
    anchors.left: parent.left;
    anchors.right: parent.right;

    height: childrenRect.height;

    property string cancelText: qsTr("×");
    property string createText: qsTr("Open");

    signal createClicked();
    signal cancelClicked();
    color: "transparent";

    Button {
        id: buttonCancel;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.margins: 0;
        text: root.cancelText;
        style: AppButtonStyleHeader {}
        height: appStyle.labelSize * 2.5;
        onClicked: {
            if (!enabled) { return; }
            cancelClicked();
            }
        }

    Button {
        id: buttonCreate;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.margins: 0;
        text: root.createText;
        style: AppButtonStyleHeader {}
        height: appStyle.labelSize * 2.5;
        onClicked: {
            if (!enabled) { return; }
            cancelClicked();
            }
        }

    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: buttonCreate.right;
        anchors.right: buttonCancel.left;
        anchors.bottom: buttonCancel.bottom;
        anchors.leftMargin: 10;
        text: qsTr("Create report");
        font.pixelSize: appStyle.textSize;
        verticalAlignment: Text.AlignVCenter;
        height: appStyle.labelSize * 2.5;
        color: appStyle.textColor;
        }

    Spacer { 
        id: spacer;
        anchors.top: buttonCancel.bottom; 
        height: 4; 
        }



}



