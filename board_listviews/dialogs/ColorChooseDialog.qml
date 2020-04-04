
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Dialog {

    signal choosenColor(var color)


    function setColor(index) {
        switch (index){
        case 0:
            return "#e8eaf6";

        case 1:
            return "#e1bee7";

        case 2:
            return "#f8bbd0";
        case 3:
            return "#c8e6c9";
        case 4:
            return "#dcedc8";
        case 5:
            return "#b2dfdb";
        case 6:
            return "#fff9c4";
        case 7:
            return "#ffecb3";
        case 8:
            return "#ffccbc";
        }
    }

    modal: true
    height: 400 + implicitHeaderHeight+implicitHeaderHeight
    width: 400
    anchors.centerIn: parent
    visible: true

    standardButtons: Dialog.Cancel
    title: qsTr("Выбор цвета")

    Component.onCompleted: standardButton(Dialog.Cancel).text = qsTr("Закрыть");

    Grid{
        id: grid
        property var currentRect: undefined
        anchors.fill: parent
        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter


onCurrentRectChanged: console.log(currentRect)
        //anchors.centerIn: parent
        //anchors.margins: 20

        rows: 3
        columns: 3

        //anchors.leftMargin: 20
        Repeater{
            id:repeater
            model:9

            Rectangle{
                height:  parent.height/(grid.rows)
                width: parent.width/(grid.columns)
                radius: 3

                color: "transparent"

                Rectangle{
                    id: colorRect
                    anchors.centerIn: parent
                    height: parent.height*.7
                    width: parent.height*.7
                    radius: height*2
                    color: setColor(index)
                    border.color: "blue"
                    border.width: 2
                    Image {
                        id: img
                        source: "qrc:/Tick"
                        anchors.fill: parent
                        scale: 0.5
                        visible: grid.currentRect === colorRect
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:
                        {
                            choosenColor(colorRect.color)

                            grid.currentRect = colorRect
                        }
                    }
                }
            }
        }
    }

}
