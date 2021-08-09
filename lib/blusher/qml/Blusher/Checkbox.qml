import QtQuick 2.12
import QtGraphicalEffects 1.0

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
  property var customCheckFunction: false

  signal clicked()

  Box {
    id: checkArea
    width: 20
    height: 20
    radius: 4
    color: 'blue'
    Image {
      id: checkImage
      source: image()
      anchors.centerIn: checkArea
      width: root.checkState !== Checkbox.CheckState.Unchecked ? 18 : 0
      height: root.checkState !== Checkbox.CheckState.Unchecked ? 18 : 0

      function image() {
        switch (root.checkState) {
        case Checkbox.CheckState.Checked:
          return 'qrc:///blusher/icons/standalone/scalable/status/checked.svg';
        case Checkbox.CheckState.Mixed:
          return 'qrc:///blusher/icons/standalone/scalable/status/mixed.svg';
        default:
          return '';
        }
      }
    }
    ColorOverlay {
      anchors.fill: checkImage
      source: checkImage
      color: '#ffffff'
    }
  }

  Text {
    x: checkArea.width
    text: root.title
    font.pixelSize: 14 * (root.window ? root.window.screenScale : 1)
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (!root.customCheckFunction) {
        root.checkFunction();
      }

      root.clicked();
    }
  }

  function checkFunction() {
    if (root.checkState === Checkbox.CheckState.Unchecked) {
      root.checkState = Checkbox.CheckState.Checked;
    } else {
      root.checkState = Checkbox.CheckState.Unchecked;
    }
  }
}
