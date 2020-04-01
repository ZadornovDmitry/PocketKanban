
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12


ComboBox {
    //width: 100//contentItem.width
    Material.background: Material.Blue
    Material.foreground: Material.White
    flat: true

    onCurrentTextChanged: {
        contentItem.text = currentText
        if (contentItem.contentWidth !== 0)
            width = contentItem.contentWidth+indicator.width+ leftPadding + rightPadding
    }
    onCountChanged: {
        var _maxWidth = 0
        for(var i = 0; i < model.rowCount(); i++){
            _maxWidth = Math.max((model.get(i).value.length+1)*Qt.application.font.pixelSize, _maxWidth)
            console.log(_maxWidth)
        }

        popup.width = _maxWidth;
    }

    //popup.width: 200
}

