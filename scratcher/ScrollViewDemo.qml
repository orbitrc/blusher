import QtQuick 2.12

import Blusher 0.1

Component {
  View {
    ScrollView {
      x: 20
      y: 20
      width: 100
      height: 100
      Box {
        width: 100
        height: 100
        color: 'red'
      }
    }
  }
}
