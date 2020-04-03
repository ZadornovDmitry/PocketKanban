import QtQuick 2.0
import QtQml.Models 2.1
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Item{
    property var imageSource:""
    property var icoColor: Material.color(Material.Blue)
    property var clickFunction: null

    width: parent.height
    height: parent.height
MouseArea{
    id: ma
    anchors.fill: parent
    onClicked: {
        clickFunction();
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

