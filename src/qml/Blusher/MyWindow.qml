import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.0

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
  property Item toolbar: null
  property Rectangle body

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

      MouseArea {
        anchors.fill: parent
        onClicked: {
          (root.menu) ? root.menu.focusedItemIndex = -1 : null
        }
      }

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

      Rectangle {
        id: _rect
        anchors.fill: parent
        color: "grey"
      }
    }

    // Window body
    Item {
      id: _bodyArea
      Layout.fillWidth: true
      Layout.fillHeight: true
    }

    Button {
      id: _testButton
      onClick: {
//        _menuArea.visible = false
        print("---_menyArea---")
        print(_menuArea.width)
        print(_menuArea.height)
      }
    }
  }

  //=======================
  // Created
  //=======================
  Component.onCompleted: {
    if (root.menu) {
//      root.menu.parent = _menuArea
//      root.menu.anchors.fill = _menuArea
      _menuArea.visible = true
    }
    if (root.toolbar) {
      root.toolbar.parent = _toolbarArea
      root.toolbar.anchors.fill = _toolbarArea
      _toolbarArea.visible = true
    }

    root.body.parent = _bodyArea
  }
}
