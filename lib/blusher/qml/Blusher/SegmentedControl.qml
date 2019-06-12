import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
  id: root

  enum SwitchTracking {
    SelectOne,
    SelectAny,
    Momentary
  }

  default property list<Item> segments

  //===================
  // Public properties
  //===================
  property int trackingMode: SegmentedControl.SwitchTracking.SelectOne
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
    spacing: 0
    Repeater {
      model: root.segments.length
      Rectangle {
        width: 50
        height: 28
        clip: true
        color: (root.selectedSegmentIndex !== index) ? "grey" : "blue"
        border.color: "black"

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
          onClicked: {
            root.selected(index)
          }
        }
      }
    }
  }

  onSelected: {
    root.selectedSegmentIndex = index
  }
}
