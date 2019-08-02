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

  }

  RowLayout {
    Repeater {
      model: listModel
      delegate: FocusScope {
        id: scope
        focus: true
        width: rectangle.width
        height: rectangle.height
        x: rectangle.x
        y: rectangle.y
        Rectangle {
          id: rectangle
          implicitWidth: _text.implicitWidth
          height: 40
          color: "lightgreen"
          Keys.onReturnPressed: {
            print('enter!' + _text.text)
            rectangle.focus = false
          }

          Text {
            id: _text
            text: name
            font.bold: rectangle.activeFocus
          }
          MouseArea {
            anchors.fill: parent
            onClicked: {
              action()
              print('cost is ' + cost)
              scope.focus = true
              rectangle.focus = true
              print(parent.parent)
            }
          }
        }
      }
    }
  }




  Component.onCompleted: {
  }
}
