import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtGraphicalEffects 1.12
import QtQml.Models 2.12

import "../screepts/CreateDatabase.js" as CreateDatabase
import "dialogs"

Rectangle {
    id: root

    width: 300; height: 400
    signal dataChanged();
    property string taskType: ""
    property bool needUpdate: false
    property var updateModelFunction: function (){

        var db = CreateDatabase.getDatabase();

        db.transaction(
                    function(tx) {
                        var tasks = tx.executeSql("select * from tasks where state_id = (select id from States where state = '"+taskType+"') order by priority");
                        if (tasks.rows.length < listModel.count)
                            listModel.remove(0, listModel.count - tasks.rows.length);
                        for (var i = 0; i < tasks.rows.length; i++) {
                            listModel.set(i,{
                                            'value': tasks.rows.item(i).name,
                                            'priority': tasks.rows.item(i).priority,
                                            'id': tasks.rows.item(i).task_id,
                                            'taskColor': tasks.rows.item(i).color
                                        })
                        }
                    }
                    );

    }

    onNeedUpdateChanged: {updateModelFunction(); needUpdate = false;}


    DelegateModel {
        id: visualModel

        model: ListModel
        {
            id:listModel

        }
        delegate: TaskDelegate{taskType: root.taskType}
    }

    ListView {
        id: view
        currentIndex: -1
        anchors { fill: parent; margins: 10 }

        model: visualModel

        spacing: 20
        cacheBuffer: 50

        Component.onCompleted: updateModelFunction()
    }
}
