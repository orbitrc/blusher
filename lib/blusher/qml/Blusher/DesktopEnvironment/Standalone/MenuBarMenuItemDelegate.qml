import QtQuick 2.12

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher
import "." as Standalone

Item {
  id: root

  property var menuItem: null
  property bool menuBarActive: false
  property bool focused: false
  property bool bold: false

  signal pressed(var mouse)
  signal clicked(var mouse)
  signal entered()
  signal exited()

  width: _text.implicitWidth
  MouseArea {
    anchors.fill: parent
    hoverEnabled: root.menuBarActive

    onPressed: {
      root.pressed(mouse);
    }
    onClicked: {
      root.clicked(mouse);
    }
    onEntered: {
      root.entered();
    }
    onExited: {
      root.exited();
    }

    Standalone.MenuItemStyler {
      anchors.fill: parent
      visible: root.focused
    }
    Text {
      id: _text

      text: root.menuItem.title

      anchors.verticalCenter: parent.verticalCenter
      rightPadding: 7.0   // 5.0 + styler's margin
      leftPadding: 7.0    // 5.0 + styler's margin
      font.pixelSize: 14 * DesktopEnvironment.pixelsPerDp
      font.bold: root.bold
    }
  }
}
