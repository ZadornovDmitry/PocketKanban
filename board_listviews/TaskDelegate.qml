import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtGraphicalEffects 1.12
import QtQml.Models 2.12

import "../screepts/CreateDatabase.js" as CreateDatabase
import "dialogs"

MouseArea {
    id: dragArea

    property string taskType: ""
    property bool held: false


    states:[
        State {// state when clicked on delegate to show bootom buttons
            name: "ShowOptions"
        },
        State {// when pencil button clicked to edit task name
            name: "EditMode"
            PropertyChanges {
                target: taskName
                readOnly: false
            }
        }
    ]

    state: ""
// this timer runs when new task added to set active focus to text field with task name
    // without it active focus doesnt set
    Timer {
        id: timer
              interval: 10; running: false; repeat: false
              onTriggered: state = "EditMode";
          }

    Component.onCompleted: {
        // if its new task from pushing button '+' we have to open delegate and set active focus to text field with task name
       if (id == 0)timer.start();
    }

    function getOptionsItem(__taskType)
    {
        console.log(__taskType)
        switch (__taskType)
        {
        case 'TODO':
            return "ToDoTaskDelegateOptions.qml";
        case 'DOING':
            return "DoTaskDelegateOptions.qml";
        case 'DONE':
            return "DoneTaskDelegateOptions.qml";
        }
    }


    anchors { left: parent.left; right: parent.right }
    height: content.height

    drag.target: held ? content : undefined
    drag.axis: Drag.YAxis

    pressAndHoldInterval: 500

    onPressAndHold: {held = true; view.currentIndex = index;}
    onReleased:
    {
        // if it was drag and drop update database
        if (held){
            var db = CreateDatabase.getDatabase();

            db.transaction(
                        function(tx) {
                            for (var i=0; i< visualModel.items.count; i++ ){
                                var query = "update Tasks set priority = " + (i+1) + " where task_id = " + visualModel.items.get(i).model.id;
                                tx.executeSql(query);
                            }
                        }
                        )
            listModel.clear();
            updateModelFunction();
        }
        held = false;
    }

    Connections{
        target: view
        onCurrentIndexChanged:{
            if (view.currentIndex != index){
                dragArea.state = "";
            }
        }
    }

    onClicked:
    {
        view.currentIndex = index;
        if (dragArea.state == "")
            dragArea.state = "ShowOptions";
        else
            dragArea.state = "";
    }

    RectangularGlow {// shadow effect

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
        color: taskColor;

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
// Task name field
            TextField
            {
                id: taskName
                height:window.height/10 ;
                text: value
                font.pixelSize: height/5
                background: null
                verticalAlignment: Qt.AlignVCenter
                readOnly: dragArea.state != "EditMode"

                onReadOnlyChanged: forceActiveFocus();

                onPressed: {
                    view.currentIndex = index;

                    if (dragArea.state == "")
                        dragArea.state = "ShowOptions";
                    else
                        dragArea.state = "";

                }

                onEditingFinished: {
                    if (!activeFocus) return;

                    var db = CreateDatabase.getDatabase();


                    if (id == 0){

                        if (text.trim().length == 0){

                            listModel.remove(listModel.count-1);

                            return;
                        }else{
                            db.transaction(
                                        function(tx) {
                                            var query = "Insert  Into Tasks(name, board_id, state_id, color) values('" + text +"', (select board_id from ActiveBoard where id =1), (select id from States where state = 'TODO'), '"+taskColor+"')"

                                            tx.executeSql(query);
                                        }
                                        );
                            dataChanged();
                            readOnly = true;
                            updateModelFunction();


                        }
                    }else{

                        if (text.length == 0) return;


                        db.transaction(
                                    function(tx) {
                                        var query = "update Tasks set name = '" + text + "' where task_id = " + visualModel.items.get(index).model.id;
                                        tx.executeSql(query);
                                    }
                                    )
                        readOnly = true;
                    }
                }
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
                        when: dragArea.state =="ShowOptions" || dragArea.state == "EditMode" || id == 0
                        PropertyChanges {
                            target: options_rect
                            height: taskName.height/2
                        }
                    }
                ]
                transitions: Transition {
                    NumberAnimation { properties: "height"; easing.type: Easing.InOutQuad; duration: 300 }
                }
                Loader{
                    source: getOptionsItem(dragArea.taskType)
                    anchors.fill: parent
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

