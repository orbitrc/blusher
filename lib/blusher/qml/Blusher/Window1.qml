import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.0

import "DesktopEnvironment"

QtQuickWindow.Window {
  id: root

  enum WindowType {
    DocumentWindow,
    AppWindow,
    Panel,
    Dialog,
    Alert
  }

  property int type

  property Menu menu: null
  property Toolbar toolbar: null
  property Item body

  property int windowHeight
  property int windowWidth

  property int minimumFrameWidth: 0
  property int minimumFrameHeight: 0
  property int minimumBodyWidth: 0
  property int minimumBodyHeight: 0


  readonly property bool maximized: (root.visibility === QtQuickWindow.Window.Maximized)

  height: root.windowHeight * DesktopEnvironment.pixelsPerDp
  width: root.windowWidth * DesktopEnvironment.pixelsPerDp

  //  minimumWidth: root.minimumFrameWidth  // xcb error. why??
  //  minimumHeight: root.minimumFrameHeight

  color: "#d6d2d0"
  flags: root._windowFlags()

  ColumnLayout {
    id: columnLayout
    anchors.fill: parent
    spacing: 0

    // Menu bar
    Item {
      id: _menuArea
      visible: false
      Layout.preferredHeight: DesktopEnvironment.menuBarHeight * DesktopEnvironment.pixelsPerDp
      Layout.minimumHeight: DesktopEnvironment.menuBarHeight * DesktopEnvironment.pixelsPerDp
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop

      Loader {
        id: menuViewLoader
        anchors.fill: parent
      }
    }

    // Toolbar
    Item {
      id: _toolbarArea
      visible: false
      Layout.preferredHeight: 50 * DesktopEnvironment.pixelsPerDp
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
    }

    // Window body
    Item {
      id: _bodyArea
      Layout.fillWidth: true
      Layout.fillHeight: true
      children: [
        root.body
      ]
    }
  }

  FocusScope {
    id: focusScope
    focus: true

    Keys.onPressed: {
      print('main onPressed: ' + event.key)
      switch (event.key) {
      case Qt.Key_Escape:
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
      menuViewLoader.sourceComponent = DesktopEnvironment.menuDelegate
      menuViewLoader.item.menu = root.menu
      _menuArea.visible = true
    }

    if (root.toolbar) {
      root.toolbar.parent = _toolbarArea
      root.toolbar.anchors.fill = _toolbarArea
      _toolbarArea.visible = true
    }

//    root.body.parent = _bodyArea
  }

  //=======================
  // Property changed
  //=======================
  onHeightChanged: {
//    if (root.maximized) { return; }

    root.windowHeight = root.height / DesktopEnvironment.pixelsPerDp;
  }
  onWidthChanged: {
//    if (root.maximized) { return; }

    root.windowWidth = root.width / DesktopEnvironment.pixelsPerDp;
  }

  onActiveChanged: {
    if (root.active) {
      DesktopEnvironment.app.activeWindow = root;
    }
  }

  //================
  // Methods
  //================
  function giveGlobalFocus() {
    focusScope.focus = true
  }

  // Internal
  function _windowFlags() {
    if (root.type === Window.WindowType.Alert) {
      return (Qt.Dialog | Qt.CustomizeWindowHint | Qt.WindowTitleHint);
    }
    if (root.type === Window.WindowType.Panel) {
      return (Qt.Dialog | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint);
    }
    return Qt.Window;
  }
}
