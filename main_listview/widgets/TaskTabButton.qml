import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12


import "../../screepts/CreateDatabase.js" as CreateDatabase



TabButton {
    id: control
    property int tasks:0
    property bool needUpdate: false

    property int stateId:0

    function update(){

        var db = CreateDatabase.getDatabase();

        db.transaction(
        function(tx) {
            var tasks_ = tx.executeSql("select count(task_id) as taskCount from Tasks where board_id = (select board_id from ActiveBoard where id =1) and state_id = " + stateId);
            control.tasks = tasks_.rows.item(0).taskCount;

        });
    }

    onNeedUpdateChanged: {
        update();
        needUpdate = false;
    }

    text: qsTr("сделать")
    contentItem: IconLabel {
            spacing: control.spacing
            mirrored: control.mirrored
            display: control.display

            icon: control.icon
            text: control.text
            font: control.font
            color: !control.enabled ? control.Material.hintTextColor :
                control.flat && control.highlighted ? control.Material.accentColor :
                control.highlighted ? control.Material.primaryHighlightedTextColor : control.Material.foreground

            Rectangle{
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height*.8
                width: parent.height*.8
                color: "#f44336"
                radius: parent.height
                visible: tasks != 0
                Label{
                    text: tasks
                    anchors.centerIn: parent
                    color: "white"
                    font.bold: true
                }

            }
        }

}
