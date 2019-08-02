import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import ".."       // Blusher.DesktopEnvironment
import "../.."    // Blusher
import "." as Standalone

Item {
  id: root

  property Menu menu: null

  //================
  // Style
  //================
  implicitHeight: itemsView.implicitHeight
  implicitWidth: itemsView.implicitWidth
  width: this.implicitWidth

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

  GridLayout {
    id: itemsView
    property alias menuItemViewList: menuItemViewList

    rows: -1
    columns: 1
    rowSpacing: 0
    columnSpacing: 0
    // Menu items
    Repeater {
      model: root.menu.items
      id: menuItemViewList
      Standalone.MenuItemDelegate {
        menuItem: root.menu.items[index]
      }
    }
  }
}
