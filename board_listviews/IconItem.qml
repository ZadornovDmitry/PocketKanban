import QtQuick 2.0
import QtQml.Models 2.1
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Item{
    property var imageSource:""
    property var icoColor: Material.color(Material.Blue)
    width: parent.height
    height: parent.height
MouseArea{
    anchors.fill: parent
    onClicked: {
        console.log(imageSource)
    }
}
    Image {
        id: rightIco
        source:imageSource
        anchors.fill: parent
    }
    ColorOverlay {
            anchors.fill: rightIco
            source: rightIco
            color: icoColor
        }
}

