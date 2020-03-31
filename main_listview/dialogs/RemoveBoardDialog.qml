import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Dialog {
    id: createBoardDialog
    property string boardName: ""
    anchors.centerIn: parent

    height: 200
    width: label.contentWidth + 50
    visible: true
    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel

    title:  qsTr("Удаление доски")
    Component.onCompleted: {
        standardButton(Dialog.Cancel).text = qsTr("Отменить");
        standardButton(Dialog.Ok).text = qsTr("Удалить");
    }
        Label{
            id: label
            anchors.centerIn: parent
            width: parent.width
            text: qsTr("Удалить доску \"" + boardName + "\"? Все активные задачи будут удалены.
Архивированные задачи будут показаны на экране История")
        }



}
