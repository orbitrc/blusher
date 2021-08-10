import QtQuick 2.12

import Blusher 0.1

Component {
  View {
    Slider {
      id: sliderContinuous

      x: 20
      y: 20

      start: 0
      end: 200
      step: 1
      value: 50
    }
    Label {
      x: 20
      anchors.top: sliderContinuous.bottom
      text: sliderContinuous.value
    }
  }
}
