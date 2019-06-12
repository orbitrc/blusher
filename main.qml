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
        text: "first"
        onClicked: {
          sidebar.visible = true
        }
      }
    }
    ToolbarItem {
      label: "Back/Forward"
      SegmentedControl {
        trackingMode: SegmentedControl.TrackingMode.Momentary
        Segment {
          label: "back"
          image: DesktopEnvironment.icons.goPrevious
        }
        Segment {
          label: "forward"
          image: DesktopEnvironment.icons.goNext
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
        text: "Hide"
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
      color: "green"
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
