import QtQuick 2.12

import "DesktopEnvironment"

Window {
  id: root

  type: Window.WindowType.Alert
  title: ' '

  property string message: ''
  property string informativeText: ''
  readonly property alias buttons: _buttons.children

  signal ok()

  minimumHeight: 200 * DesktopEnvironment.pixelsPerDp
  maximumHeight: 200 * DesktopEnvironment.pixelsPerDp
  minimumWidth: 450 * DesktopEnvironment.pixelsPerDp
  maximumWidth: 450 * DesktopEnvironment.pixelsPerDp

  body: Item {
    anchors.fill: parent
    Image {
      id: _icon
      source: DesktopEnvironment.icons.checked.source
      sourceSize.width: 128
      sourceSize.height: 128

      // Debug
      property Rectangle graphicalDebugRect: Rectangle {
        anchors.fill: parent
        color: "#33ff00ff"
      }
      data: [ _icon.graphicalDebugRect ]
    }

    Label {
      id: _message

      text: root.message
      color: "lightblue"

      anchors.left: _icon.right
      anchors.right: parent.right
    }
    Label {
      text: root.informativeText
      color: "lightgreen"

      anchors.left: _icon.right
      anchors.right: parent.right
      anchors.top: _message.bottom
    }

    Row {
      id: _buttons

      height: 50
      layoutDirection: Qt.RightToLeft
      spacing: 12

      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      Button {
        title: 'Ok'
        onClicked: {
          root.ok();
          root.close();
        }
      }
      Button {
        title: 'Cancel'
        onClicked: {
          root.close();
        }
      }
    }
  }

  FocusScope {
    id: focusScope
    focus: true

    Keys.onPressed: {
      switch (event.key) {
      case Qt.Key_Escape:
        root.close();
        break;

      case Qt.Key_Return:
        root.buttons[0].clicked(null);
        break;

      case Qt.Key_Enter:
        print('enter');
        break;

      default:
        break;
      }
    }
  }

  onVisibleChanged: {
    if (root.visible) {
      root.requestActivate();
      focusScope.focus = true;
    }
  }
}
