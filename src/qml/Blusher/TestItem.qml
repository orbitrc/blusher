import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQml.Models 2.12

Rectangle {
  id: root

  width: 100
  height: 100
  color: "blue"
  clip: true

  /*
  Repeater {
    model: 5 //root.children
    Text {
      text: index
    }
  }
  */
  property var testProp

  ListModel {
    id: listModel

    ListElement {
      property string title: "blah"
      name: "hello"
      cost: 1
      action: function() {
        print("action!!")
      }
    }
    ListElement {
      property string title: "haha"
      name: "world"
      cost: 2
      action: function() {
        print("action2!")
      }
    }
  }

  RowLayout {
    Repeater {
      model: listModel
      delegate: Rectangle {
        implicitWidth: _text.implicitWidth
        height: 40
        color: "lightgreen"
        Text {
          id: _text
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
  }


  Component.onCompleted: {
  }
}
