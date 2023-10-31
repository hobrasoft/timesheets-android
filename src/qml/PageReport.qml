/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "api.js" as Api

Item {
    id: root;
    anchors.fill: parent;

    property int currentCategory: 0;
    property int parentCategory: 0;

    function createReport() {
        var st = [];
        for (var i = 0; i<statuses.count; i++) {
            if (statuses.get(i).checked) { st.push(statuses.get(i).status); }
            }
        var serverUrl = (settings.useSSL ? "https://" : "http://") + settings.serverName;
        var api2 = new Api.Api();
        api2.onFinished = function(json) {
            var url = serverUrl+"/public/timesheet.shtml?id=" + json.id;
            console.log("nova sestava " + url);
            Qt.openUrlExternally(url);
            initpage.loadPage("PageCategories.qml");
            }
        api2.overview(currentCategory, st);
        }

    Background {}

    ReportHeader { 
        id: header; 
        onCreateClicked: {
            createReport();
            }
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        }


    ListView {
        id: listview;
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.topMargin: header.height/5;
        anchors.bottomMargin: header.height/5;
        spacing: 5;
        clip: true;
        model: statuses;

        delegate:  Rectangle {
            width: listview.width;
            height: childrenRect.height;
            color: "#10ffffff";
            radius: 5;
            clip: true;

            MInputCheckboxField {
                id: chbox;
                label: description;
                width: listview.width;
                partiallyCheckedEnabled: false;
                checkedState: statuses.get(index).checked ? Qt.Checked : Qt.UnChecked;
                onCheckedStateChanged: {
                    statuses.setProperty (index, "checked", checkedState == Qt.Checked);
                    }
                }

/*
            CheckBox {
                id: chbox;
                anchors.top: t.top;
                anchors.left: parent.left;
                anchors.bottom: t.bottom;
                anchors.margins: 10;
                width: height;
                clip: true;
                partiallyCheckedEnabled: false;
                onCheckedStateChanged: {
                    statuses.setProperty (index, "checked", checkedState == Qt.Checked);
                    }
                }

            Rectangle {
                id: circle;
                anchors.top: t.top;
                anchors.left: chbox.right;
                anchors.bottom: t.bottom;
                anchors.margins: 20;
                width: height;
                color: statusColor;
                radius: height/2;
                }

            Text {
                id: t;
                anchors.top: parent.top;
                anchors.left: circle.right;
                anchors.right: parent.right;
                anchors.leftMargin: 10;
                text: description;
                font.pixelSize: appStyle.labelSize;
                color: appStyle.textColor;
                height: appStyle.labelSize * 3;
                verticalAlignment: Text.AlignVCenter;
                }
*/

            }
        }
}

