import QtQuick 2.0

import Blusher 0.1
import Blusher.DesktopEnvironment 0.1

MyWindow {
  visible: true
//  flags: Qt.Popup | Qt.WA_X11NetWmWindowTypeMenu
  width: 300
  height: 300
  title: "Pouch"

  menu: Menu {
    id: testMenu
    type: Menu.MenuType.MenuBarMenu
    title: "MainMenu"

    MenuItem {
      title: "File"
      submenu: Menu {
        type: Menu.MenuType.Submenu
        title: "File"
        MenuItem {
          title: "Create New"
          submenu: Menu {
            type: Menu.MenuType.Submenu
            title: "Create New"
            MenuItem {
              title: "New Text File"
            }
            MenuItem {
              title: "New Folder"
            }
          }
        }

        MenuItem {
          separator: true
        }
        MenuItem {
          title: "Quit"
        }
      }
    }
    MenuItem {
      title: "Edit"
      submenu: Menu {
        type: Menu.MenuType.Submenu
        title: "Edit"
        MenuItem {
          title: "Copy"
        }
        MenuItem {
          title: "Paste"
        }
      }
    }
    MenuItem {
      title: "Help"
    }
  }

  toolbar: Toolbar {
    ToolbarItem {
      label: "Show"
      Button {
        width: 50
        height: 20
        title: "first"
        onClicked: {
          sidebar.visible = true
        }
      }
    }
    ToolbarItem {
      label: "Back/Forward"
      SegmentedControl {
        trackingMode: SegmentedControl.TrackingMode.Momentary
        separated: true
        Segment {
          label: "back"
          image: DesktopEnvironment.icons.goPrevious
        }
        Segment {
          label: "forward"
          image: DesktopEnvironment.icons.goNext
        }

        onSelected: {
          if (index === 0) {
            print('back')
          } else {
            print('forward')
          }
        }
      }
    }
  }

  body: SplitView {
    Rectangle {
      id: sidebar
      color: "#ff8080"
      width: 200
      Button {
        width: 100
        height: 50
        title: "Hide"
        onClicked: {
          parent.visible = false
        }
      }
      TestItem {
        testProp: testMenu
        y: 100
      }
    }
    Rectangle {
      color: "white"
      Rectangle {
        border.color: "black"
        width: 200
        height: 30
        Text {
          id: _lorem
          text: "Lorem ipsum (" + _lorem.font.family + ")"
//          font.pixelSize: 1
        }
      }
      Text {
        y: 30
        font.pixelSize: 10
        text: _lorem.font.pointSize + "pt, (" + _lorem.font.pixelSize + "px)"
      }

      Button {
        y: 50
        id: _testButtonZoomOut
        title: "zoom out"
        onClicked: {
          _lorem.font.pointSize -= 1
        }
      }
      Button {
        y: 100
        id: _testButtonZoomIn
        title: "zoom in"
        onClicked: {
          _lorem.font.pointSize += 1
        }
      }
    }

    Component.onCompleted: {
      this.setViewFillHeight(0, true)
      this.setViewFillHeight(1, true)
      this.setViewFillWidth(1, true)

      this.setViewMinimumWidth(0, 100)
    }
  }

  Component.onCompleted: {
  }
}
