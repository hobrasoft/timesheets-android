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

    property int user: 0;

    Background {}

    TimesheetsHeader {
        id: header;
        saveEnabled: name.text !== '' && login.text !== '';
        text: qsTr("New user");
        deleteVisible: true;
        deleteEnabled: user > 0;
        onSaveClicked: {
            saveData();
            }
        onCancelClicked: {
            initpage.loadPage("PageUsers.qml");
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
            id: name;
            anchors.top: parent.top;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Name");
            }

        MInputTextField {
            id: login;
            anchors.top: name.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Login");
            }

        MInputCheckboxField {
            id: admin;
            anchors.top: login.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Administrator");
            }

        MInputCheckboxField {
            id: xenabled;
            anchors.top: admin.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Enabled");
            }

        }

    Component.onCompleted: {
        loadData();
        }


    QuestionDialog {
        text: qsTr("Do you really want to delete the user?");
        id: deleteDialog;
        onAccepted: {
            var api = new Api.Api();
            api.onFinished = function() {
                initpage.loadPage("PageUsers.qml");
                };
            api.removeUser(root.user);
            nitpage.loadPage("PageUsers.qml");
            }
        }


    function loadData() {
        if (user > 0) {
            var api2 = new Api.Api();
            api2.onFinished = function(json) {
                name.text = json.name;
                login.text = json.login;
                header.text = json.name;
                admin.checkedState = json.admin ? Qt.Checked : Qt.Unchecked;
                xenabled.checkedState = json.enabled ? Qt.Checked : Qt.Unchecked;
                }
            api2.users(user);
            }
        }

    function saveData() {
        var data = (user !== 0) 
            ? { admin: admin.checkedState == Qt.Checked, enabled: xenabled.checkedState == Qt.Checked, login: login.text, name: name.text, user: user }
            : { admin: admin.checkedState == Qt.Checked, enabled: xenabled.checkedState == Qt.Checked, login: login.text, name: name.text };
        var api = new Api.Api();
        api.saveUser(data);
        api.onFinished = function(json) {
            initpage.loadPage("PageUsers.qml");
            }
        }


}

