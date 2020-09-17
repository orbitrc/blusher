import QtQuick 2.12
import QtQuick.Layouts 1.12

import Blusher 0.1

View {
  id: root

  enum DisplayMode {
    IconAndLabel,
    IconOnly,
    LabelOnly
  }

  default property list<ToolbarItem> items

  //=========================
  // Public Properties
  //=========================
  property int displayMode: Toolbar.DisplayMode.IconAndLabel

  //============
  // Style
  //============
  anchors.left: parent.left
  anchors.right: parent.right
  height: 50

  RowLayout {
    id: layout
    anchors.fill: parent
    spacing: 1
    Repeater {
      model: root.items
    }
  }

  //==============
  // Created
  //==============
  Component.onCompleted: {
    for (let i = 0; i < root.items.length; ++i) {
      const item = root.items[i]
      item.parent = layout
      // Fill height.
      item.Layout.fillHeight = true
      if (item.width > 0) {
        item.Layout.preferredWidth = item.implicitWidth;
      }
    }
  }
}
