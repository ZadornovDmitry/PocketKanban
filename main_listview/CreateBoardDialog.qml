import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog {
    id: createBoardDialog
    property string boardName: ""
    anchors.centerIn: parent

    height: 200
    width: parent.width/3
    visible: true
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    title:  qsTr("Создать доску")
    Component.onCompleted: {
        standardButton(Dialog.Cancel).text = qsTr("Отмена")
    }
    Column{
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        spacing: 5
        Label{
            text: qsTr("Название")
        }

        TextField{
            height: 40
            width: parent.width
            onTextChanged: {
                boardName = text;
            }
        }
    }
}
