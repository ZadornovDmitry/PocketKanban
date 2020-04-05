import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import "../board_listviews"
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

        TabButton {
            text: qsTr("сделать")

        }
        TabButton {
            text: qsTr("делаю")
        }
        TabButton {
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
                TasksListView
                {
                    id: tasksListView
                    anchors.fill: parent
                    taskType: type
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
