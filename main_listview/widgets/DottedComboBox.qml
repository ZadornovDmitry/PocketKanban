
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12


ComboBox {

    id: control
    property int popupWidth: 200
    Material.background: Material.Blue
    Material.foreground: Material.White
    flat: true
    indicator: Rectangle{color:"transparent"}
    currentIndex: -1

    contentItem:
        Item{
        id: contentItem_
        height: parent.height
        width: parent.height
        Image {
            id: icon
            height: parent.height*.45
            width: parent.height*.45
            source: "qrc:/MoreMenu"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit



            mipmap: true
            scale: 0.8

        }
    }

    popup.width: popupWidth
    popup.y: height
    popup.x: -popup.width+width
}

