import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
  id: root

  enum DisplayMode {
    IconAndLabel,
    IconOnly,
    LabelOnly
  }

  default property list<Item> items

  //=========================
  // Public Properties
  //=========================
  property int displayMode: Toolbar.DisplayMode.IconAndLabel

  //============
  // Style
  //============
  anchors.fill: parent
//  color: "lightgreen"

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
      item.Layout.fillHeight = true
//      if (item.width > 0) {
//        item.Layout.preferredWidth = view.width
//      }
    }
  }
}
