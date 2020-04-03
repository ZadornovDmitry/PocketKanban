import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtGraphicalEffects 1.12
import QtQml.Models 2.1

import "../screepts/CreateDatabase.js" as CreateDatabase

Rectangle {
    id: root

    width: 300; height: 400

    function updateModel(){
        todoModel.clear();
        var db = CreateDatabase.getDatabase();

        db.transaction(
                    function(tx) {
                        var tasks = tx.executeSql("select * from tasks where state_id = (select id from States where state = 'TODO') order by priority");
                        for (var i = 0; i < tasks.rows.length; i++) {
                            todoModel.append
                                    ({
                                         'value': tasks.rows.item(i).name,
                                         'priority': tasks.rows.item(i).priority,
                                         "id": tasks.rows.item(i).task_id
                                     })
                            //console.log(tasks.rows.item(i).priority);
                        }
                    }
                    );
    }


    Component {
        id: dragDelegate

        MouseArea {
            id: dragArea

            property bool held: false

            anchors { left: parent.left; right: parent.right }
            height: content.height

            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis



            onPressAndHold: held = true
            onReleased:
            {
                held = false;
                var db = CreateDatabase.getDatabase();

                db.transaction(
                    function(tx) {
                        for (var i=0; i< visualModel.items.count; i++ ){
                            var query = "update Tasks set priority = " + (i+1) + " where task_id = " + visualModel.items.get(i).model.id;
                            console.log(query);
                            tx.executeSql(query);
                            console.log("lalal " + visualModel.items.get(i).model.priority)
                        }
                    }
                )
                updateModel();


            }

            Connections{
                target: view
                onCurrentIndexChanged:{
                    if (view.currentIndex != index){
                        options_rect.state = "";
                    }
                }
            }

            onClicked:
            {
                view.currentIndex = index;

                if (options_rect.state == "")
                    options_rect.state = "visible";
                else
                    options_rect.state = "";
            }
            RectangularGlow {

                   id: effect
                   anchors.fill: content
                   glowRadius: 7
                   spread: 0.1
                   color: "light gray"

               }

            Rectangle {
                id: content


                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: dragArea.width; height: column.implicitHeight
                color: "#CEEDF4";

                radius: 3
                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2
                states: State {
                    when: dragArea.held

                    ParentChange { target: content; parent: root }
                    AnchorChanges {
                        target: content
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }

                Column {
                    id: column
                    anchors { fill: parent; margins: 10 }

                    TextField
                    {
                        id: taskName
                        height:window.height/10 ;
                        text: value
                        font.pixelSize: height/5
                        background: null
                        verticalAlignment: Qt.AlignVCenter

                    }
                    Rectangle{
                        id: options_rect
                        color: "transparent"
                        height: 0
                        width: parent.width

                        states:
                        [
                            State {
                                name: "visible"

                                PropertyChanges {
                                    target: options_rect
                                    height: taskName.height/2

                                }
                            }
                        ]
                        transitions: Transition {
                                  NumberAnimation { properties: "height"; easing.type: Easing.InOutQuad; duration: 300 }
                              }
                        Row{
                            id: icoRow


                            height: parent.height/2
                            width: parent.width
                            spacing: 25
                            layoutDirection: Qt.RightToLeft
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 17

                            IconItem{
                                imageSource: "qrc:/RightArrow"
                            }
                            IconItem{
                                imageSource: "qrc:/Pencil"
                            }
                            IconItem{
                                imageSource: "qrc:/Bin"
                            }
                            IconItem{
                                imageSource: "qrc:/Art"
                            }
                        }
                    }
                }
            }
            DropArea {
                anchors { fill: parent; margins: 10 }

                onEntered: {
                    visualModel.items.move(
                            drag.source.DelegateModel.itemsIndex,
                            dragArea.DelegateModel.itemsIndex)

                }

            }
        }
    }
    DelegateModel {
        id: visualModel

        model: ListModel
        {
            id:todoModel
            onDataChanged:{
                console.log("data changed")
            }
        }
        delegate: dragDelegate
    }

    ListView {
        id: view
        currentIndex: -1
        anchors { fill: parent; margins: 10 }

        model: visualModel

        spacing: 20
        cacheBuffer: 50

        Component.onCompleted: updateModel()


    }
}
