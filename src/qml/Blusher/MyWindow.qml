import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.0

import Blusher.DesktopEnvironment 0.1

Window {
  id: root
  enum WindowType {
    DocumentWindow,
    AppWindow,
    Panel,
    Dialog,
    Alert
  }

  property Menu menu: null
  property Toolbar toolbar: null
  property Item body

  color: "#d6d2d0"

  ColumnLayout {
    id: columnLayout
    anchors.fill: parent
    spacing: 0

    // Menu bar
    Item {
      id: _menuArea
      visible: false
      Layout.preferredHeight: 30
      Layout.minimumHeight: 30
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop

      MenuView {
        menu: root.menu
        anchors.fill: parent
      }
    }

    // Toolbar
    Item {
      id: _toolbarArea
      visible: false
      Layout.preferredHeight: 50
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
    }

    // Window body
    Item {
      id: _bodyArea
      Layout.fillWidth: true
      Layout.fillHeight: true
    }

    Button {
      id: _testButton
      text: "activeFocus: " + _testButton.activeFocus
      onClicked: {
        print('Window._testButton')
      }
    }
  }

  FocusScope {
    id: focusScope
    focus: true

    Keys.onPressed: {
      print('main onPressed: ' + event.key)
      switch (event.key) {
      case Qt.Key_Escape:
        if (DesktopEnvironment.menuOpen) {
          root.menu.close()
          DesktopEnvironment.menuClosed()
        }

        break;

      case Qt.Key_Right:
        break;

      default:
        break;
      }
    }

  }

  //=======================
  // Created
  //=======================
  Component.onCompleted: {
    if (root.menu) {
      _menuArea.visible = true
    }
    if (root.toolbar) {
      root.toolbar.parent = _toolbarArea
      root.toolbar.anchors.fill = _toolbarArea
      _toolbarArea.visible = true
    }

    root.body.parent = _bodyArea
  }

  //================
  // Methods
  //================
  function giveGlobalFocus() {
    focusScope.focus = true
  }

  //================
  // Debug
  //================
}
