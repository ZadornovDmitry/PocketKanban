import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
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
                    id: cb_boards
                    width:parent.width/3
                    height: parent.height
                    Material.background: Material.Blue
                    Material.foreground: Material.White
                    flat: true

                    model: [ "Banana", "Apple", "Coconut" ]
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


                                text:qsTr("Rename")
                            }

                            Button{
                                flat: true
                                text:qsTr("Remove")
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
        delegate: SwipeViewDelegate{contentHeigh: mainListView.height}
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds
    }
}
