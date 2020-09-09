import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQml.Models 2.12

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
