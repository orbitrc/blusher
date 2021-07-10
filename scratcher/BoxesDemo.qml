import QtQuick 2.12

import Blusher 0.1

Component {
  id: boxesDemo

  View {
    Box {
      id: box1

      x: 10
      y: 20
      width: 80
      height: 60
      color: 'red'
      topLeftRadius: 10
      bottomLeftRadius: 20
      bottomRightRadius: 30
      topRightRadius: 25

      Label {
        text: 'bl::Box'
      }
    }
    Box {
      id: box2

      anchors.top: box1.top
      anchors.left: box1.right
      anchors.leftMargin: 10

      width: 80
      height: 60
      color: 'blue'
      topLeftRadius: 1  // This not affect because `radius` is set.
      radius: 20
    }

    Box {
      id: box3

      anchors.top: box1.top
      anchors.left: box2.right
      anchors.leftMargin: 10

      width: 80
      height: 60
      color: 'green'
      topLeftRadius: 10
      bottomLeftRadius: 10
      borderWidth: 2
      borderColor: '#000000'
    }

    Box {
      id: box4

      anchors.top: box1.top
      anchors.left: box3.right
      anchors.leftMargin: 10

      width: 80
      height: 60
      color: 'orange'
      topRightRadius: 10
      bottomRightRadius: 10
      borderWidth: 1
      borderColor: '#000000'
    }
  }
}
