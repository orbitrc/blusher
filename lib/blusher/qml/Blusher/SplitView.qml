import QtQuick 2.12
import QtQuick.Layouts 1.12

import "DesktopEnvironment"

Item {
  id: root

  enum Orientation {
    Horizontal,
    Vertical
  }

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
    property bool resizing: false
    property int resizingViewIndex: -1
    property real resizingViewMinimumWidth: 0
    property real dividerOffset: 0
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
        anchors.left: undefined
        anchors.right: undefined
        anchors.horizontalCenter: _divider.horizontalCenter
        anchors.verticalCenter: undefined // _divider.verticalCenter
        cursorShape: Qt.SplitHCursor

        onPressed: {
          _private.resizingViewMinimumWidth = root.getViewMinimumWidth(index)
          _private.dividerOffset = mouse.x
          _private.resizing = true
          DesktopEnvironment.app.cursor = DesktopEnvironment.Cursor.ResizeLeftRight;
        }

        onReleased: {
          _private.resizingViewMinimumWidth = 0
          _private.resizing = false
          DesktopEnvironment.app.cursor = DesktopEnvironment.Cursor.Auto;
        }

        onPositionChanged: {
          const view = root.views[index];
          view.Layout.preferredWidth += (mouse.x - _private.dividerOffset);
          // Minimun width
          if (view.Layout.preferredWidth < _private.resizingViewMinimumWidth) {
            view.Layout.preferredWidth = _private.resizingViewMinimumWidth;
          }
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

  function getViewMinimumWidth(index) {
    return root.views[index].Layout.minimumWidth
  }

  function setViewMinimumWidth(index, width) {
    root.views[index].Layout.minimumWidth = width
  }
}
