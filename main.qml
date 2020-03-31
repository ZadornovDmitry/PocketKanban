import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import "main_listview"
import "screepts/CreateDatabase.js" as CreateDatabase
import "main_listview/dialogs"

ApplicationWindow {
    id: window
    property alias dialogLoader_: dialogLoader
    visible: true
    width: 1080
    height: 700

    title: qsTr("Pocket Kanban")


    Loader{
        id: dialogLoader

        anchors.fill: parent
    }

    Drawer {
              id: drawer
              width: 0.66 * parent.width
              height: parent.height
              interactive: true
           }


    MainListView{/*width: window.width; height: window.height;*/ anchors.fill:parent}


}
