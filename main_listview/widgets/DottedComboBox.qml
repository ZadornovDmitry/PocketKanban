
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12


ComboBox {

    id: control
    property int popupWidth: 200
    Material.background: Material.Blue
    Material.foreground: Material.White
    flat: true
    indicator: Rectangle{color:"transparent"}
    currentIndex: -1

    contentItem:
        Rectangle{
        rotation: 90
        color: "transparent"
        height: parent.width
        width: parent.width

        Label{
            x:parent.width/2-width/2
            y:parent.height/2-height
            height: parent.height/2

            text :"..."
            font.pointSize:  30
            verticalAlignment: Qt.AlignVCenter
            color: "white"

        }
    }
    popup.width: popupWidth
    popup.y: height
    popup.x: -popup.width+width
}

