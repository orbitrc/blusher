import QtQuick 2.0

import Blusher 0.1

View {
  id: slider

  width: 200
  height: 20

  enum SliderType {
    Continuous,
    TicksWithSnap,
    TicksWithoutSnap
  }

  property real start: 0.0
  property real end: 1.0
  property real step: 0.0
  property real value: 0
  property real _realValue: knob.x / (track.width * 0.01) * (end * 0.01)

  on_RealValueChanged: {
    if (step === 0.0) {
      this.value = this._realValue;
    } else {
      let max = this._realValue === this.end;
      if (max) {
        this.value = this.end;
      } else {
        this.value = closestMultiple(this._realValue, this.step);
      }
    }
  }

  function closestMultiple(n, x) {
    if (x === 0) {
      return n;
    }
    n = n + Math.floor(x / 2);
    n = n - (n % x);

    return n;
  }

  Rectangle {
    id: track

    anchors.horizontalCenter: slider.horizontalCenter
    anchors.verticalCenter: slider.verticalCenter
    width: slider.width - ((knob.width / 2) * 2)
    height: 6
    radius: 50
  }

  Rectangle {
    id: trackFilled

    anchors.top: track.top
    anchors.left: track.left
    width: knob.x
    height: 6
    radius: track.radius
    color: 'blue'
  }

  Rectangle {
    id: knob

    width: slider.height
    height: slider.height
    radius: 50
    border.width: 2
    border.color: 'black'

    MouseArea {
      id: thumbDrag

      anchors.fill: parent

      drag.target: knob
      drag.threshold: 0
      drag.minimumX: 0
      drag.maximumX: slider.width - knob.width
      drag.minimumY: 0
      drag.maximumY: 0
      drag.onActiveChanged: {
        print('active changed');
      }
    }
  }

  Rectangle {
    anchors.fill: parent
    color: "#55ff0000"
  }
}
