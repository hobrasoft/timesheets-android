/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12
import "api.js" as Api

Item {
    id: pageStatuses;
    anchors.fill: parent;

    function loadData() {
        busyIndicator.setBusy(true);

        var api = new Api.Api();
        api.onFinished = function(json) {
            listview.model = json;
            busyIndicator.setBusy(false);
            }
        api.statusesAll();
        }

    Component.onCompleted: {
        loadData();
        }

    Background {}

    AppBusyIndicator { id: busyIndicator; }

    TimesheetsHeader {
        id: header;
        saveVisible: false;
        text: qsTr("Statuses");
        addVisible: true;
        addEnabled: true;
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        onAddClicked: {
            initpage.loadPage("PageStatus.qml");
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

        delegate: Rectangle {
            width: listview.width;
            height: childrenRect.height + appStyle.h4Size/5;
            color: "#10ffffff";
            radius: 5;
            clip: true;

            function edit(item) {
                initpage.loadPage("PageStatus.qml", { status: item.status });
                }

            Item {
                id: spacer;
                width: appStyle.labelSize / 2;
                }

            ColumnLayout {
                id: leftpart;
                anchors.left: spacer.right;
                spacing: 2;

                Item {
                    height: childrenRect.height;
                    Text {
                        id: tdescription;
                        anchors.top: parent.top;
                        font.pixelSize: appStyle.labelSize;
                        color: appStyle.textColor;
                        text: modelData.description + " (" + modelData.abbreviation + ")";
                        }
                    }

                Item {
                    height: childrenRect.height;
                    Text {
                        id: tclosed;
                        color: appStyle.textColor;
                        font.pixelSize: appStyle.smallSize;
                        text: qsTr("Closed") + ": " + ((modelData.closed) ? qsTr("Yes") : qsTr("No"));
                        }
                    Text {
                        id: tignored;
                        anchors.left: tclosed.right;
                        anchors.leftMargin: appStyle.labelSize;
                        color: appStyle.textColor;
                        font.pixelSize: appStyle.smallSize;
                        text: qsTr("Ignored") + ": " + ((modelData.ignored) ? qsTr("Yes") : qsTr("No"));
                        }
                    Text {
                        id: tcan_be_run;
                        anchors.left: tignored.right;
                        anchors.leftMargin: appStyle.labelSize;
                        color: appStyle.textColor;
                        font.pixelSize: appStyle.smallSize;
                        text: qsTr("Can be run") + ": " + ((modelData.can_be_run) ? qsTr("Yes") : qsTr("No"));
                        }
                    }

                Item {
                    height: childrenRect.height;
                    Text {
                        id: tnext;
                        color: appStyle.textColor;
                        font.pixelSize: appStyle.smallSize;
                        text: qsTr("Next") + ": "  + (modelData.next.map(function(x) { return x.abbreviation; }).join(", "));
                        }
                    }

                }

            MouseArea {
                anchors.fill: parent;
                onPressAndHold: {
                    edit(modelData);
                    }
                }

            }
        }

    ApplicationMenu {
        id: appmenu;
        }

}


