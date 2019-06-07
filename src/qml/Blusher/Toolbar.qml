import QtQuick 2.12

Item {
  id: root

  enum DisplayMode {
    IconAndLabel,
    IconOnly,
    LabelOnly
  }

  //=========================
  // Public Properties
  //=========================
  property int displayMode: Toolbar.DisplayMode.IconAndLabel
}
