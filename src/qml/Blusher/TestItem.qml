import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQml.Models 2.12

Item {
  id: root

  width: 100
  height: 100

  /*
  Repeater {
    model: 5 //root.children
    Text {
      text: index
    }
  }
  */

  ListModel {
    id: listModel


    ListElement {
      property string msg: "blah"
      name: "hello"
      cost: 1
      action: function() {
        print("action!!")
      }
    }
  }

  ListView {
    model: listModel
    delegate: Rectangle {
      width: 100
      height: 50
      Text {
        text: name
      }
      MouseArea {
        anchors.fill: parent
        onClicked: {
          action()
          print('cost is ' + cost)
          print('parent is ' + parent)
        }
      }
    }
  }


  Component.onCompleted: {
  }
}
