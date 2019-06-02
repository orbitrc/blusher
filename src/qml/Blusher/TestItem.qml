import QtQuick 2.0
import QtQuick.Layouts 1.12

Item {
  id: root
  Repeater {
    model: 5 //root.children
    Text {
      text: index
    }
  }

  Component.onCompleted: {
    print('repeater items: ' + root.children.length)
    print(root.children[0])
  }
}
