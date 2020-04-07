import QtQuick 2.12

import Blusher 0.1

View {
  id: root

  enum CheckState {
    Unchecked = 0,
    Checked = 1,
    Mixed = 2
  }

  width: 100
  height: 20

  property string title: ''
  property int checkState: 0

  signal clicked()

  Rectangle {
    id: checkArea
    width: 20
    height: 20
    radius: 4
    color: 'red'
    Rectangle {
      anchors.centerIn: parent
      width: 14
      height: 14
      radius: 4
      Image {
        source: image()

        function image() {
          switch (root.checkState) {
          case Checkbox.CheckState.Checked:
            return '../../icons/standalone/scalable/status/checked.svg';
          case Checkbox.CheckState.Mixed:
            return '';
          default:
            return '';
          }
        }
      }
    }
  }

  Text {
    x: checkArea.width
    text: root.title
    font.pixelSize: 14
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      root.clicked();
    }
  }
}
