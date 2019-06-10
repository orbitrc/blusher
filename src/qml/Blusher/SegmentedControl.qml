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
        color: (root.selectedSegmentIndex !== index) ? "grey" : "blue"
        border.color: "black"

        Text {
          text: root.segments[index].label
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
