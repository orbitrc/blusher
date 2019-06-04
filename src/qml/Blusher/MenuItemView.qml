import QtQuick 2.12

Item {
  id: root
  clip: true

  //====================
  // Public Properties
  //====================
  property MenuItem menuItem: null
  property string text: ""

  //====================
  // Signals
  //====================
  signal clicked()
  signal entered()
  signal exited()

  implicitWidth: _text.implicitWidth
//  width: 20 // For avoiding implicitWidth bug...
  height: 30

  Rectangle {
    id: _styler
    visible: (root.menuItem.focused)
    anchors.fill: parent
    anchors.margins: 2
    border.width: 0
    color: "#bbb4b1"
    radius: 3
  }

  Text {
    id: _text
    text: root.text
    anchors.verticalCenter: parent.verticalCenter
    rightPadding: 7.0   // 5.0 + styler's margin
    leftPadding: 7.0    // 5.0 + styler's margin
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true

    onClicked: {
      root.clicked()
    }
    onEntered: {
      root.entered()
    }
    onExited: {
      root.exited()
    }
  }

  //=======================
  // Methods
  //=======================
  function hasSubmenu() {
    return menuItem.hasSubmenu()
  }
}
