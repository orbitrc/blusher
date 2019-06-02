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
    title: "TestMenu"

    MenuItem {
      title: "File"
      submenu: Menu {
        type: Menu.MenuType.Submenu
        title: "File"
        MenuItem {
          title: "New Text File"
          onFocusedIn: {
            print("hello!")
          }
        }
        MenuItem {
          title: "New Folder"
        }
      }
    }
    MenuItem {
      title: "Edit"
    }
    MenuItem {
      title: "Help"
    }
  }

  body: Rectangle {
    Button {
      width: 100
      height: 50
      text: "Click"
      onClick: {
        console.log(DesktopEnvironment.msg)
      }
    }
    TestItem {
      y: 100
    }
  }
}
