import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import "../board_listviews"
import "../screepts/CreateDatabase.js" as CreateDatabase

Item{
    property var contentHeigh: 0
    property alias tabBar:tabBar_
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

        Item {
            id: firstPage
            TasksListView
            {
                anchors.fill: parent
                updateModelFunction: function (__model){
                        var db = CreateDatabase.getDatabase();

                        db.transaction(
                                    function(tx) {
                                        var tasks = tx.executeSql("select * from tasks where state_id = (select id from States where state = 'TODO') order by priority");
                                        if (tasks.rows.length < __model.count)
                                            __model.remove(0, __model.count - tasks.rows.length);
                                        for (var i = 0; i < tasks.rows.length; i++) {
                                            __model.set(i,{
                                                              'value': tasks.rows.item(i).name,
                                                              'priority': tasks.rows.item(i).priority,
                                                              'id': tasks.rows.item(i).task_id,
                                                              'taskColor': tasks.rows.item(i).color
                                                          })
                                        }
                                    }
                                    );
                    }

            }
            //Rectangle{height: contentHeigh; width: parent.width; color: "lightblue"}

        }
        Item {
            id: secondPage
            Text{text:"lalala"}
        }
        Item {
            id: thirdPage
            Text{text:"lalala"}
        }


    }


}
