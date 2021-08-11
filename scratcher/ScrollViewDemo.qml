import QtQuick 2.12

import Blusher 0.1

Component {
  ScrollView {
    x: 20
    y: 20
    width: 100
    height: 100
    Box {
      id: box1
      width: 100
      height: 100
      color: 'red'
    }
    Box {
      id: box2
      anchors.top: box1.bottom
      width: 100
      height: 50
      color: 'blue'
    }
    Box {
      id: box3
      anchors.top: box2.bottom
      width: 100
      height: 30
      color: 'orange'
    }
  }
}
