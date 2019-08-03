import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher
import "." as Standalone

import "../../../../js/path.js" as Path

QtQuickWindow.Window {
  id: root

  property var menu: null // not used
  property var items: []
  property int focusedItemIndex: -1

  flags: Qt.Popup
  //================
  // Style
  //================
  height: itemsView.implicitHeight
  width: itemsView.implicitWidth

  Rectangle {
    id: _menuStyler
    anchors.fill: parent
    color: "#d6d2d0"
    border.width: 1
    border.color: "#ddffffff"
    radius: 3
  }
  DropShadow {
    anchors.fill: _menuStyler
    verticalOffset: 0
    radius: 7.0
    color: "#000000"
    source: _menuStyler
  }

  ColumnLayout {
    id: itemsView
    property alias menuItemViewList: menuItemViewList

    spacing: 0
    // Menu items
    Repeater {
      model: root.items
      id: menuItemViewList
      Standalone.MenuItemDelegate {
        menuItem: root.items[index]
      }
    }
  }

  Component.onCompleted: {
  }
}
