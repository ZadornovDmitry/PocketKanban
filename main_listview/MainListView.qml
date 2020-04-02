import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtQuick.LocalStorage 2.12 as Sql
import QtGraphicalEffects 1.12

import "../screepts/CreateDatabase.js" as Database
import "dialogs"
import "widgets"

Item{
    ListView{
        id: mainListView
        anchors.fill: parent
        // this is header that disapear when scroling down and wise versa
        header: ToolBar
        {
            id: toolBar
            width: mainListView.width
            Row{
                anchors.fill: parent
                spacing: 10
                anchors.leftMargin: 20

                MenuWidget{
                    id:menuWidget
                    height: parent.height;width:parent.height
                    onClickedFunction: function(){drawer.visible = true; anim.start()}
                    NumberAnimation {id:anim; target: drawer; property: "position"; to: 1; duration: 167}
                    Connections{
                        target: drawer
                        onAboutToHide:{
                            menuWidget.menuState="menu";
                        }
                        onAboutToShow:{
                            menuWidget.menuState="back";
                        }
                    }
                }

                // combobox with list of boards
                BoardsComboBox {
                    id: cb_boards
                    //width:parent.width/2

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
                    // show when new board need to be ctreated
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
                // just spacer
                Item{
                    height: parent.height
                    width:mainListView.width - cb_boards.width - (parent.height*2)-dottedCb.width
                }

                DottedComboBox{
                    id: dottedCb
                    height: parent.height
                    width:parent.height + parent.height/2
                    popupWidth: 200

                    model:["Переименовать", "Удалить"]
                    onCurrentIndexChanged: {
                        if (currentIndex == 0){
                            window.dialogLoader_.sourceComponent = renameBoardDialog;
                            currentIndex = -1;
                        }else if (currentIndex == 1){
                            window.dialogLoader_.sourceComponent = removeBoardDialog;
                            currentIndex = -1;
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

                    // dialog shows on remove board
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
        }
        headerPositioning: ListView.PullBackHeader
        model:[1]
        delegate: swipeDelegate
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds


    }

    // this is delegate for main listview
    // it contains three boards with tasks(todo, do, done)
    Component{
        id: swipeDelegate
        SwipeViewDelegate{
            id:swipe
            contentHeigh: mainListView.height
            Connections{
                target: swipe.tabBar
                onCurrentIndexChanged:{
                    addTaskBtn.state = swipe.tabBar.currentIndex==0?"":'ivisible';
                }
            }
        }

    }
    // button for adding new task on active board
    RoundButton{
        id: addTaskBtn
        radius: parent.height
        width: parent.height/11
        height: parent.height/11
        x: window.width-width-20
        y: window.height-height-20
        text: "+"
        Material.foreground: "white"
        Material.background: Material.color(Material.Blue)
        font.pixelSize: 21

        transitions: [Transition {
                from: ""
                to: "ivisible"
                NumberAnimation { properties: "height,width"; easing.type: Easing.InOutQuad; duration: 200}
                NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad; duration: 300}
            },
            Transition {
                from: "ivisible"
                to: ""
                NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad; duration: 200}
                NumberAnimation { properties: "height,width"; easing.type: Easing.InOutQuad; duration: 300}
            }]
        states: [State {
                name: "ivisible"
                PropertyChanges {
                    target: addTaskBtn
                    x: window.width-width-20-width/2
                    y: window.height-height-20-width/2
                    height: 0
                    width:0

                }
            }]
    }
}
