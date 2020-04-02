import QtQuick 2.0

Item{
    id:menuItem
    property var onClickedFunction: ""
    property var menuState: "menu"
    height: parent.height;width:parent.height

    MouseArea{
        anchors.fill: parent
        onClicked: {

            menuItem.onClickedFunction();
        }
    }

    Item {
      id: mainItem

      property real radius: 2
      property int animationDuration: 500
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        //anchors.centerIn: parent
        height: parent.height*0.5
        width: parent.width*0.4

      Rectangle {
        id: bar1
        x: 0
        y: parent.height * .25
        width: parent.width
        height: parent.height * .1
        radius: parent.radius
        antialiasing: true
      }

      Rectangle {
        id: bar2
        x: 0
        y: parent.height * .5
        width: parent.width
        height: parent.height * .1
        radius: parent.radius
        antialiasing: true
      }

      Rectangle {
        id: bar3
        x: 0
        y: parent.height * .75
        width: parent.width
        height: parent.height * .1
        radius: parent.radius
        antialiasing: true
      }



      state: menuItem.menuState
      states: [
        State {
          name: "menu"
        },

        State {
          name: "back"
          PropertyChanges { target: mainItem; rotation: 180 }
          PropertyChanges { target: bar1; rotation: 45; width: mainItem.width * .6; x: mainItem.width * .48; y: mainItem.height * .33 - bar1.height }
          PropertyChanges { target: bar2; width: mainItem.width * .8; x: mainItem.width * .2; y: mainItem.height * .5 - bar2.height }
          PropertyChanges { target: bar3; rotation: -45; width: mainItem.width * .6; x: mainItem.width * .48; y: mainItem.height * .67 - bar3.height }
        }
      ]

      transitions: [
        Transition {
          RotationAnimation { target: mainItem; direction: RotationAnimation.Clockwise; duration: mainItem.animationDuration; easing.type: Easing.InOutQuad}
          PropertyAnimation { target: bar1; properties: "rotation, width, x, y"; duration: mainItem.animationDuration; easing.type: Easing.InOutQuad }
          PropertyAnimation { target: bar2; properties: "rotation, width, x, y"; duration: mainItem.animationDuration; easing.type: Easing.InOutQuad }
          PropertyAnimation { target: bar3; properties: "rotation, width, x, y"; duration: mainItem.animationDuration; easing.type: Easing.InOutQuad }
        }
      ]
    }
}
