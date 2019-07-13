import QtQuick 2.0

import Blusher 0.1
import Blusher.DesktopEnvironment 0.1

Window {
  visible: true
  width: 400
  height: 300
  title: "Pouch"

  menu: Menu {
    id: testMenu
    type: Menu.MenuType.MenuBarMenu
    title: "MainMenu"

    MenuItem {
      title: DesktopEnvironment.menus.applicationMenu.title
      submenu: DesktopEnvironment.menus.applicationMenu
    }
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
      width: 160
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

      TextField {
        id: _lorem
        width: 200
        height: 30
        text: "Lorem ipsum (" + _lorem.font.family + ")"
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
          _lorem.font.size -= 1
        }
      }
      Button {
        y: 100
        id: _testButtonZoomIn
        title: "zoom in"
        onClicked: {
          _lorem.font.size += 1
        }
      }
      Button {
        y: 150
        id: _testButtonAlert
        title: "Alert"
        onClicked: {
          alert.visible = true
        }
      }
    }

    Component.onCompleted: {
      this.setViewFillHeight(0, true)
      this.setViewFillHeight(1, true)
      this.setViewFillWidth(1, true)

      this.setViewMinimumWidth(0, 100)
      this.setViewMinimumWidth(1, 100)
    }
  }

  Window {
    id: alert
    title: " "
    type: Window.WindowType.Alert
    flags: Qt.Dialog
    modality: Qt.WindowModal //Qt.ApplicationModal

    minimumHeight: 200
    maximumHeight: 200
    minimumWidth: 300
    maximumWidth: 300

    body: Item {
      width: 100
      height: 100

      Button {
        title: "resize"
        onClicked: {
          alert.minimumHeight -= 50
          alert.maximumHeight -= 50
        }
      }
    }
  }

  Component.onCompleted: {
    print(Process.env.BLUSHER_PLATFORM)
    print(Process.app)
  }

//  Connections {
//    target: Process.app
//    onObjectNameChanged: {
//      print("changed!");
//    }
//  }
}
