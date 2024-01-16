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
    id: pageUsers;
    anchors.fill: parent;

    function loadData() {
        busyIndicator.setBusy(true);

        var api = new Api.Api();
        api.onFinished = function(json) {
            listview.model = json;
            busyIndicator.setBusy(false);
            }
        api.users();
        }

    Component.onCompleted: {
        loadData();
        }

    Background {}

    AppBusyIndicator { id: busyIndicator; }

    TimesheetsHeader {
        id: header;
        saveVisible: false;
        text: qsTr("Users");
        addVisible: true;
        addEnabled: true;
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        onAddClicked: {
            initpage.loadPage("PageUser.qml");
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
            height: childrenRect.height;
            color: "#10ffffff";
            radius: 5;
            clip: true;

            function edit(item) {
                initpage.loadPage("PageUser.qml", { user: item.user });
                }

            Item {
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.leftMargin: appStyle.h4Size/7;
                anchors.rightMargin: appStyle.h4Size/7;
                height: iconedit.height + appStyle.h4Size;

                Item {
                    id: leftpart;
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: iconedit.left;
                    anchors.bottom: parent.bottom;
                    anchors.leftMargin: iconedit.width / 3;
                    
                    Item {
                        id: line1;
                        anchors.top: parent.top;
                        height: childrenRect.height;
                        Text {
                            id: tusername;
                            font.pixelSize: appStyle.labelSize;
                            color: appStyle.textColor;
                            text: modelData.name;
                            }
                        }
                    
                    Item {
                        id: line2;
                        anchors.top: line1.bottom;
                        height: childrenRect.height;
                        Text {
                            id: trole;
                            color: appStyle.textColor;
                            font.pixelSize: appStyle.smallSize;
                            text: qsTr("User role") + ": " + (modelData.admin ? qsTr("Admin") : qsTr("User"));
                            }

                        Text {
                            id: tlogin;
                            anchors.left: trole.right;
                            anchors.leftMargin: appStyle.labelSize;
                            color: appStyle.textColor;
                            font.pixelSize: appStyle.smallSize;
                            text: qsTr("Login") + ": " + modelData.login;
                            }

                        Text {
                            id: tenabled;
                            anchors.left: tlogin.right;
                            anchors.leftMargin: appStyle.labelSize;
                            color: appStyle.textColor;
                            font.pixelSize: appStyle.smallSize;
                            text: modelData.enabled ? "" : qsTr("Disabled");
                            }

                        }

                    }

                Image {
                    id: iconedit;
                    source: "edit.svg";
                    height: appStyle.h4Size;
                    fillMode: Image.PreserveAspectFit;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    anchors.rightMargin: width/3;

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: iconedit;
                        color: appStyle.textColor;
                        source: iconedit;
                        }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            edit(modelData);
                            }
                        }
                    }

                }

            }
        }

    ApplicationMenu {
        id: appmenu;
        }

}


