import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
  id: root

  default property list<Item> views

  property int orientation: Qt.Horizontal

  anchors.fill: parent

  GridLayout {
    id: layout

    rows: (root.orientation === Qt.Horizontal) ? 1 : -1
    columns: (root.orientation === Qt.Vertical) ? 1 : -1
    anchors.fill: parent
    rowSpacing: 1
    columnSpacing: 1

    Repeater {
      model: root.views
    }
  }

  //==============
  // Created
  //==============
  Component.onCompleted: {
    for (let i = 0; i < root.views.length; ++i) {
      root.views[i].parent = layout
    }
  }

  //=================
  // Methods
  //=================
  function setViewFillWidth(index, value) {
    root.views[index].Layout.fillWidth = value
  }

  function setViewFillHeight(index, value) {
    root.views[index].Layout.fillHeight = value
  }
}
