import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12

import "../board_listviews"
import "widgets"
import "../screepts/CreateDatabase.js" as CreateDatabase

Item{
    property var contentHeigh: 0
    property alias tabBar:tabBar_
    property alias taskBoards: itemRepeater
    width:parent.width
    height: swipeView.height

    TabBar {
        id: tabBar_
        currentIndex: swipeView.currentIndex
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left

        TaskTabButton {
           text: qsTr("сделать")
           stateId: 1
        }
        TaskTabButton {
            stateId: 2
            text: qsTr("делаю")
        }
        TaskTabButton {
            stateId: 3
            text: qsTr("сделано")
        }
    }

    SwipeView {
        id: swipeView
        width: parent.width
        height: contentHeigh
        anchors.top: tabBar_.bottom
        currentIndex: tabBar_.currentIndex

        Component.onCompleted: {// getting data from db States table
            var db = CreateDatabase.getDatabase();

            db.transaction(
            function(tx) {
                var states = tx.executeSql("select * from States");
                for (var i = 0; i < states.rows.length; i++) {
                    repeaterModel.insert(i, {'type': states.rows.item(i).state});
                }
            });
        }
        // repeater take data from database and make items according to States table
        Repeater{
            id: itemRepeater
            model:ListModel{id: repeaterModel}
            Item {
                property alias innerObject: tasksListView
                //signal listModelCountChanged(count)
                TasksListView
                {
                    id: tasksListView
                    anchors.fill: parent
                    taskType: type
                }

                Connections{
                    target: tasksListView.listViewModel
                    onCountChanged:{

                        switch (tasksListView){
                        case itemRepeater.itemAt(0).innerObject:
                            tabBar_.itemAt(0).needUpdate = true;
                            break;
                        case itemRepeater.itemAt(1).innerObject:
                            tabBar_.itemAt(1).needUpdate = true;
                            break;
                        case itemRepeater.itemAt(2).innerObject:
                            tabBar_.itemAt(2).needUpdate = true;
                            break;
                        }
                    }
                }

                Connections{
                    target: tasksListView
                    onDataChanged:{
                        for (var i=0 ; i<itemRepeater.count; i++)
                        {
                            if (itemRepeater.itemAt(i) !== tasksListView){
                                itemRepeater.itemAt(i).innerObject.needUpdate = true;
                            }
                        }
                    }
                }
            }
        }
    }
}
