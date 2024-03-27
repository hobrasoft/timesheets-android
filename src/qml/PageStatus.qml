/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import "api.js" as Api

Item {
    id: root;
    anchors.fill: parent;

    property string status: "";
    property bool somethingChecked: false;
    property var  checkedStatuses: [];

    function loadData() {
        var api2 = new Api.Api();
        api2.onFinished = function(jsona) {
            if (status != "") {
                var api1 = new Api.Api();
                api1.onFinished = function(json) {
                    tstatus.text = json.status;
                    abbreviation.text = json.abbreviation;
                    description.text = json.description;
                    header.text = json.description;
                    can_be_run.checkedState = json.can_be_run ? Qt.Checked : Qt.Unchecked;
                    closed.checkedState = json.closed ? Qt.Checked : Qt.Unchecked;
                    ignored.checkedState = json.ignored ? Qt.Checked : Qt.Unchecked;
                    for (var i=0; i<json.next.length; i++) {
                        if (json.next[i].status == "") { continue; }
                        checkedStatuses.push(json.next[i].status);
                        }
                    listview.model = jsona;
                    }
                api1.status(status);
              } else {
                listview.model = jsona;
                }
            }
        api2.statusesAll();
        }

    function saveData() {
        var data = { 
            status: tstatus.text,
            abbreviation: abbreviation.text,
            description: description.text,
            can_be_run: can_be_run.checkedState == Qt.Checked,
            close: closed.checkedState == Qt.Checked,
            ignored: ignored.checkedState == Qt.Checked,
            next: checkedStatuses.map(function(x) { return { status: x } })
            }

        console.log(JSON.stringify(data));

        var api = new Api.Api();
        api.saveStatus(data);
        api.onFinished = function(json) {
            initpage.loadPage("PageStatuses.qml");
            }
        }

        
    function isChecked(data) {
        if (typeof data !== 'object') { return false; }
        if (typeof data.status === 'undefined') { return false; }
        return checkedStatuses.includes(data.status);
        }  

    Background {}

    TimesheetsHeader {
        id: header;
        saveEnabled: tstatus.text !== '' && abbreviation.text !== '' && description.text !== '';
        text: qsTr("New status");
        deleteVisible: true;
        deleteEnabled: status != "";
        onSaveClicked: {
            saveData();
            }
        onCancelClicked: {
            initpage.loadPage("PageStatuses.qml");
            }
        onDeleteClicked: {
            deleteDialog.visible = true;
            }
        }

    Item {
        id: body
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        MInputTextField {
            id: tstatus;
            anchors.top: parent.top;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            enabled: status == '';
            label: qsTr("Status (primary key)");
            }

        MInputTextField {
            id: abbreviation;
            anchors.top: tstatus.bottom
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Abbreviation");
            }

        MInputTextField {
            id: description;
            anchors.top: abbreviation.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Description");
            }

        MInputCheckboxField {
            id: can_be_run;
            anchors.top: description.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Can be run");
            }

        MInputCheckboxField {
            id: closed;
            anchors.top: can_be_run.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Closed");
            }

        MInputCheckboxField {
            id: ignored;
            anchors.top: closed.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Ignored");
            }

        Text {
            id: lbls;
            anchors.top: ignored.bottom;
            anchors.topMargin: height/3;
            anchors.left: parent.left;
            anchors.right: parent.right;
            font.pixelSize: appStyle.labelSize;
            font.family: "Helvetica";
            color: appStyle.textColor;
            text: qsTr("Following statuses");
            }

        ListView {
            id: listview;
            anchors.top: lbls.bottom;
            anchors.topMargin: ignored.height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            spacing: 5;

            delegate: Rectangle {
                width: listview.width;
                height: checker.height + appStyle.h4Size/2;
                color: "#10ffffff";
                radius: 5;
                clip: true;

                Item {
                    id: spacer;
                    width: appStyle.labelSize/2;
                    }

                MInputCheckbox {
                    id: checker;
                    anchors.left: spacer.right;
                    anchors.verticalCenter: parent.verticalCenter;
                    checked: isChecked(modelData);
                    onClicked: {
                        if (checker.checked && !isChecked(modelData)) {
                            checkedStatuses.push(modelData.status);
                            somethingChecked = checkedStatuses.length > 0;
                            return;
                            }
                        if (!checker.checked && isChecked(modelData)) {
                            const index = checkedStatuses.indexOf(modelData.status);
                            if (index < 0) { return; }
                            checkedStatuses.splice(index, 1);
                            somethingChecked = checkedStatuses.length > 0;
                            return;
                            } 
                        }
                    }

                Text {
                    anchors.left: checker.right;
                    anchors.verticalCenter: parent.verticalCenter;
                    font.pixelSize: appStyle.labelSize;
                    color: appStyle.textColor;
                    text: modelData.description + " (" + modelData.abbreviation + ")";
                    }

                }

            }

        }

    Component.onCompleted: {
        loadData();
        }

    QuestionDialog {
        text: qsTr("Do you really want to delete the status?\nStatus used in a ticket could not be deleted.");
        id: deleteDialog;
        onAccepted: {
            var api = new Api.Api();
            api.onFinished = function() {
                initpage.loadPage("PageStatuses.qml");
                };
            console.log("remove status " + status);
            api.removeStatus(status);
            initpage.loadPage("PageStatuses.qml");
            }
        }

}

