import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtQuick.LocalStorage 2.12 as Sql
import "../screepts/CreateDatabase.js" as Database
import "dialogs"
Item{


    ListView{
        id: mainListView
        anchors.fill: parent

        header: ToolBar
        {
            id: toolBar
            width: mainListView.width
            Row{
                anchors.fill: parent
                spacing: 10
                anchors.leftMargin: 20
                Rectangle
                {
                    id: menuBtn
                    height: parent.height;width:parent.height
                    color: "transparent"
                    Rectangle{
                        anchors.centerIn: parent
                        height: parent.height/4*2-5
                        width: parent.width/4*2-5
                        color: "transparent"
                        Column{
                            anchors.fill: parent
                            anchors.topMargin: 5

                            spacing: 3

                            Rectangle{
                                height: 2
                                width: parent.width
                            }
                            Rectangle{
                                height: 2
                                width: parent.width
                            }
                            Rectangle{
                                height: 2
                                width: parent.width
                            }
                        }
                    }

                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {drawer.visible = true; anim.start()}
                        NumberAnimation {id:anim; target: drawer; property: "position"; to: 1; duration: 167}
                    }
                }
                ComboBox {
                    id: cb_boards// combobox with list of boards
                    width:parent.width/3
                    height: parent.height
                    Material.background: Material.Blue
                    Material.foreground: Material.White
                    flat: true
                    textRole: "value"
                    model: ListModel{ id: boards_model }

                    function updateModel(){// reading from databse and refill model with new data
                        var db = Database.getDatabase();

                        db.transaction(
                                    function(tx) {
                                        var tasks = tx.executeSql("select * from boards order by board_id DESC");
                                        boards_model.clear();

                                        for (var i = 0; i < tasks.rows.length; i++) {
                                            boards_model.append
                                                    ({
                                                         value: tasks.rows.item(i).name,
                                                         id: tasks.rows.item(i).board_id

                                                     })
                                            console.log(tasks.rows.item(i).name);
                                        }
                                        boards_model.append// for creating new board. Have to be allways in end of list
                                                ({
                                                     value: "Создать доску..."
                                                 })
                                    }
                                    );
                        cb_boards.findActiveBoard();
                    }

                    function findActiveBoard(){
                        var db = Database.getDatabase();
                        var activeBoard;
                        db.transaction(
                                    function(tx) {
                                        // finding active board that was selected in last time
                                        activeBoard = tx.executeSql("select b.name from Boards as b where b.board_id = (select a.board_id from ActiveBoard as a)").rows.item(0).name;
                                    }
                                    );
                        // setting active board to current index
                        currentIndex = find(activeBoard);
                    }

                    Component.onCompleted: {
                        cb_boards.updateModel()
                    }
                    onCurrentIndexChanged: {// if creating new board choosen show dialog

                        if (currentIndex == boards_model.rowCount()-1)
                            window.dialogLoader_.sourceComponent = createBoardDialog
                        else{
                            var db = Database.getDatabase();

                            db.transaction(
                                        function(tx) {
                                            var sql = "update ActiveBoard set board_id=" + boards_model.get(currentIndex).id + " where id = 1"
                                            tx.executeSql(sql);
                                        }
                            )
                        }
                    }
                    Component{
                        id: createBoardDialog

                        CreateBoardDialog{

                            onRejected: {
                                cb_boards.findActiveBoard();
                                window.dialogLoader_.sourceComponent = undefined
                            }
                            onAccepted: {

                                var db = Database.getDatabase();
                                var activeBoardId;
                                db.transaction(
                                            function(tx) {
                                                activeBoardId = tx.executeSql("insert into Boards values(?,?)", ["",boardName]);
                                                var sql = "update ActiveBoard set board_id=" + activeBoardId.insertId + " where id = 1"
                                                tx.executeSql(sql);

                                            }
                                )
                                cb_boards.updateModel();
                                window.dialogLoader_.sourceComponent = undefined
                            }
                        }
                    }
                }
                Item{
                    height: parent.height
                    width:mainListView.width - cb_boards.width - (parent.height*2)-70
                }

                Rectangle{
                    id: dots
                    height: parent.height
                    width: parent.height

                    color: "transparent"

                    Column{
                        anchors.topMargin: 15
                        anchors.bottomMargin: 10
                        anchors.fill: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 2
                        //white dots
                        Rectangle{
                            height: 4
                            width: 4
                            radius: width
                        }
                        Rectangle{
                            height: 4
                            width: 4
                            radius: width
                        }
                        Rectangle{
                            height: 4
                            width: 4
                            radius: width
                        }

                    }

                    Popup {
                        id: popup

                        y:parent.height
                        x:parent.width - width

                        //width: mainListView.width/3

                        focus: true

                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                        ColumnLayout{
                            anchors.fill:parent
                            Button{
                                id: btnRename

                                flat:true


                                text:qsTr("Переименовать")
                                onClicked: {
                                    popup.close();
                                    window.dialogLoader_.sourceComponent = renameBoardDialog;
                                }
                            }

                            Button{
                                flat: true
                                text:qsTr("Удалить")
                                onClicked: {
                                    popup.close();
                                    window.dialogLoader_.sourceComponent = removeBoardDialog;
                                }
                            }

                            Component{
                                id: renameBoardDialog
                                RenameBoardDialog{
                                    boardName: cb_boards.currentText
                                    onRejected: {
                                        window.dialogLoader_.sourceComponent = undefined
                                    }
                                    onAccepted: {

                                        var db = Database.getDatabase();
                                        var activeBoardId;
                                        db.transaction(
                                                    function(tx) {
                                                        tx.executeSql("update Boards set name = '" + boardName + "' where board_id = (select board_id from ActiveBoard)");
                                                    }
                                        )
                                        cb_boards.updateModel();
                                        window.dialogLoader_.sourceComponent = undefined
                                    }
                                }
                            }


                            Component{
                                id: removeBoardDialog
                                RemoveBoardDialog{
                                    boardName: cb_boards.currentText
                                    onRejected: {
                                        window.dialogLoader_.sourceComponent = undefined
                                    }
                                    onAccepted: {

                                        var db = Database.getDatabase();
                                        var activeBoardId;
                                        db.transaction(
                                                    function(tx) {
                                                        tx.executeSql("delete from Boards where board_id = (select board_id from ActiveBoard)");
                                                        tx.executeSql("update ActiveBoard set board_id = (SELECT MAX(board_id) FROM boards) where id = 1");
                                                    }
                                        )
                                        cb_boards.updateModel();
                                        window.dialogLoader_.sourceComponent = undefined
                                    }
                                }
                            }

                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {popup.open();}
                    }
                }
            }
        }
        headerPositioning: ListView.PullBackHeader
        model:[1]
        delegate: swipeDelegate
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds


    }
Component{
    id: swipeDelegate
    SwipeViewDelegate{
        id:swipe
        contentHeigh: mainListView.height
        Connections{
            target: swipe.tabBar
            onCurrentIndexChanged:{
                addTaskBtn.state = swipe.tabBar.currentIndex==0?"":'unvisible';
            }
        }
    }

}

    RoundButton{
        id: addTaskBtn
        radius: parent.height*0.2
        width: parent.height*0.12
        height: parent.height*0.12
        x: window.width-width-20
        y: window.height-height-20
        text: "+"
        Material.foreground: "blue"
        Material.background: "light blue"
        font.pixelSize: 45
        transitions: [Transition {
                from: ""
                to: "unvisible"
                NumberAnimation { properties: "height,width"; easing.type: Easing.InOutQuad; duration: 200}
                NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad; duration: 300}
            },
            Transition {
                            from: "unvisible"
                            to: ""
                            NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad; duration: 200}
                            NumberAnimation { properties: "height,width"; easing.type: Easing.InOutQuad; duration: 300}
                        }]
        states: [State {
                name: "unvisible"
                PropertyChanges {
                    target: addTaskBtn
                    x:window.width-width-20-width/2
                    y:window.height-height-20-width/2
                    height: 0
                    width:0

                }
            }]
    }
}
