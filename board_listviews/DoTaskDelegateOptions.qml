import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql
import QtGraphicalEffects 1.12
import QtQml.Models 2.12

import "../screepts/CreateDatabase.js" as CreateDatabase
import "dialogs"


Row{
    id: icoRow


    height: parent.height/2
    width: parent.width
    spacing: 25
    layoutDirection: Qt.RightToLeft
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 17

    IconItem{
        imageSource: "qrc:/RightArrow"
        clickFunction: function()
        {
            var db = CreateDatabase.getDatabase();

            db.transaction(
                        function(tx) {
                            var query = "update Tasks set state_id = (select state_id from Tasks where task_id = " + visualModel.items.get(index).model.id + ") + 1 where task_id = " +visualModel.items.get(index).model.id;
                            tx.executeSql(query);
                            updateModelFunction(listModel);
                        }
                        );
            dataChanged();
        }
    }
    IconItem{
        imageSource: "qrc:/BackArrow"
        clickFunction: function() {
            var db = CreateDatabase.getDatabase();

            db.transaction(
                        function(tx) {
                            var query = "update Tasks set state_id = (select state_id from Tasks where task_id = " + visualModel.items.get(index).model.id + ") - 1 where task_id = " + visualModel.items.get(index).model.id;
                            tx.executeSql(query);
                            updateModelFunction(listModel);
                        }
                        );
            dataChanged();
        }
    }
    IconItem{
        imageSource: "qrc:/Bin"
        clickFunction: function()
        {
            var db = CreateDatabase.getDatabase();

            db.transaction(
                        function(tx) {
                            var query = "delete from Tasks where task_id = " + visualModel.items.get(index).model.id;
                            tx.executeSql(query);
                            updateModelFunction(listModel);
                        }
                        )
        }
    }
    IconItem{
        imageSource: "qrc:/Art"
        clickFunction: function() {
            dialogLoader.sourceComponent = colorChooseDialog;
        }
        Connections{
            target: dialogLoader.item
            ignoreUnknownSignals: true
            onChoosenColor:{
                if (index === view.currentIndex){
                    dialogLoader.sourceComponent = undefined
                    //content.color = color
                    var db = CreateDatabase.getDatabase();

                    db.transaction(
                                function(tx) {
                                    var query = "update Tasks set color = '" + color + "' where task_id = " + visualModel.items.get(index).model.id;
                                    tx.executeSql(query);
                                }
                                );
                    updateModelFunction(listModel);
                }
            }
        }

        Component{
            id: colorChooseDialog
            ColorChooseDialog{
                onRejected: {
                    dialogLoader.sourceComponent = undefined;
                }
            }
        }
    }
}

