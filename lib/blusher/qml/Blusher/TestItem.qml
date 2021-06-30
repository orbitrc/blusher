import QtQuick 2.12

import Blusher 0.1

View {
  id: root

  Rectangle {
    id: rect
    anchors.fill: parent
    color: "cyan"
    Component.onCompleted: {
//      print(parent);
    }
  }

  Component.onCompleted: {
//    print('TestItem onCompleted: ' + rect.width + 'x' + rect.height);
//    print(`View: ${root.width}x${root.height}`);
  }
}
