import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtGraphicalEffects 1.12
import QtQml.Models 2.12

import "../screepts/CreateDatabase.js" as CreateDatabase
import "dialogs"

Rectangle {
    id: root

    width: 300; height: 400

    property var updateModelFunction: undefined

    DelegateModel {
        id: visualModel

        model: ListModel
        {
            id:listModel

        }
        delegate: TaskDelegate{}
    }

    ListView {
        id: view
        currentIndex: -1
        anchors { fill: parent; margins: 10 }

        model: visualModel

        spacing: 20
        cacheBuffer: 50

        Component.onCompleted: updateModelFunction(listModel)
    }
}
