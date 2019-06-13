import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
  id: root

  enum TrackingMode {
    SelectOne,
    SelectAny,
    Momentary
  }

  default property list<Item> segments

  //===================
  // Public properties
  //===================
  property int trackingMode: SegmentedControl.TrackingMode.SelectOne
  property bool separated: false
  property int selectedSegmentIndex: -1

  //=================
  // Signals
  //=================
  signal selected(int index)

  //=================
  // Style
  //=================

  //===============
  // Items
  //===============
  RowLayout {
    spacing: (!root.separated) ? 0 : 2
    Repeater {
      model: root.segments.length
      Rectangle {
        id: _segment

        width: 50
        height: 28
        clip: true
        color: "#e0e0e0"
        border.color: "black"

        property bool active: false

        state: "NotSelectedAndNotActive"
        states: [
          State {
            name: "NotSelectedAndNotActive"
            PropertyChanges { target: _segment; color: "#e0e0e0" }
          },
          State {
            name: "NotSelectedAndActive"
            PropertyChanges { target: _segment; color: "cyan" }
          },
          State {
            name: "SelectedAndNotActive"
            PropertyChanges { target: _segment; color: "#3e3e3e" }
          },
          State {
            name: "SelectedAndActive"
            PropertyChanges { target: _segment; color: "#3e3e3e" }
          }

        ]

        Text {
          text: root.segments[index].label
          visible: (root.segments[index].image === null)
        }

        Image {
          source: (root.segments[index].image !== null) ? root.segments[index].image.source : ""
          visible: (root.segments[index].image !== null)
          fillMode: Image.Stretch
          width: 24
          height: 24
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
          anchors.fill: parent
          onPressed: {
            _segment.active = true
            if (_segment.state === "NotSelectedAndNotActive") {
              _segment.state = "NotSelectedAndActive"
            }
          }
          onReleased: {
            _segment.active = false
            if (_segment.state === "NotSelectedAndActive") {
              _segment.state = "NotSelectedAndNotActive"
            }
          }

          onClicked: {
            root.selected(index)
            if (root.trackingMode !== SegmentedControl.TrackingMode.Momentary) {
              _segment.state = "SelectedAndNotActive"
            }
          }
        }
      }
    }
  }

  onSelected: {
    if (root.trackingMode === SegmentedControl.TrackingMode.Momentary) {
      return
    }

    root.selectedSegmentIndex = index
  }
}
