import QtQuick 2.0

import Blusher 0.1
import Blusher.DesktopEnvironment 0.1

MyWindow {
  visible: true
//  flags: Qt.FramelessWindowHint
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
      label: "hello"
      Button {
        width: 50
        height: 20
        text: "first"
      }
    }
  }

  body: SplitView {
    Rectangle {
      color: "red"
      width: 200
      height: 200
      Button {
        width: 100
        height: 50
        text: "Click"
        onClicked: {
          console.log(DesktopEnvironment.msg)
          DesktopEnvironment.setMsg("Hello")
        }
      }
      TestItem {
        testProp: testMenu
        y: 100
      }
    }
    Rectangle {
      width: 200
      height: 200
      color: "green"
    }

    Component.onCompleted: {
      this.setViewFillHeight(0, true)
      this.setViewFillHeight(1, true)
      this.setViewFillWidth(1, true)
    }
  }

  Component.onCompleted: {
  }
}
