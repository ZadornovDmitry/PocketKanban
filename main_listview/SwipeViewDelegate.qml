import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../board_listviews"

Item{
    property var contentHeigh: 0
    width:parent.width
    height: swipeView.height

    TabBar {
        id: tabBar
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
        anchors.top: tabBar.bottom
        currentIndex: tabBar.currentIndex

        Item {
            id: firstPage
            TodoListView{anchors.fill: parent}
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
