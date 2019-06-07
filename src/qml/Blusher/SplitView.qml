import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
  id: root

  default property list<Item> views

  //=========================
  // Public Properties
  //=========================
  property int orientation: Qt.Horizontal

  //=========================
  // Private Properties
  //=========================
  property QtObject _private: QtObject {
    id: _private
    property bool test: false
  }

  anchors.fill: parent

  // Views
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

  // Dividers
  Repeater {
    model: root.views.length - 1
    Rectangle {
      id: _divider

      visible: root.views[index].visible

      width: 1
      height: 1
      x: root.views[index].width
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      color: "black"
      MouseArea {
        width: 5
        height: 5
        anchors.top: _divider.top
        anchors.bottom: _divider.bottom
        anchors.horizontalCenter: _divider.horizontalCenter
        cursorShape: Qt.SplitHCursor

        onPositionChanged: {
          root.views[index].Layout.preferredWidth += mouse.x
        }
      }
    }
  }

  //==============
  // Created
  //==============
  Component.onCompleted: {
    for (let i = 0; i < root.views.length; ++i) {
      const view = root.views[i]
      view.parent = layout
      if (view.width > 0) {
        view.Layout.preferredWidth = view.width
      }
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
