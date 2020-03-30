import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import "../screepts/CreateDatabase.js" as CreateDatabase

ListView {
    anchors.fill: parent
    model:ListModel{id:todoModel}
    delegate:
        ItemDelegate{
        height: 35
        width: parent.width
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        Rectangle{
            anchors.fill: parent
            color: "yellow"
            Label{
                anchors.centerIn: parent
                text: value
            }
        }
    }

    Component.onCompleted: {

        var db = CreateDatabase.getDatabase();

        db.transaction(
                    function(tx) {
                        var tasks = tx.executeSql("select name from tasks");
                        for (var i = 0; i < tasks.rows.length; i++) {
                            todoModel.append
                                    ({
                                         'value': tasks.rows.item(i).name
                                     })
                            console.log(tasks.rows.item(i).name);
                        }
                    }
                    );

    }
}
