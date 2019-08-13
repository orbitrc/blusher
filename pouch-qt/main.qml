import QtQuick 2.0
import QtQuick.Layouts 1.12

import Blusher 0.1
import Blusher.DesktopEnvironment 0.1

import "src/modules"
import "src/components"

Item {
  id: application

  property var store: QtObject {
    property bool showSidebar: true
  }

  property Menu mainMenu: Menu {
    id: mainMenu
    type: Menu.MenuType.MenuBarMenu
    title: 'Blusher Main Menu'
    items: [
      // File
      {
        path: '/file/',
        title: 'File'
      },
      {
        path: '/file/create-new/',
        title: "Create New"
      },
      {
        path: '/file/create-new/text',
        title: "New Text File"
      },
      {
        path: '/file/create-new/folder',
        title: "New Folder"
      },
      {
        path: '/file/separator1',
        separator: true
      },
      {
        path: '/file/quit',
        title: "Quit"
      },
      // Edit
      {
        path: '/edit/',
        title: "Edit"
      },
      {
        path: '/edit/copy',
        title: "Copy",
        shortcut: DesktopEnvironment.KeyModifier.Control | Qt.Key_C
      },
      {
        path: '/edit/paste',
        title: "Paste",
        shortcut: DesktopEnvironment.KeyModifier.Control | Qt.Key_V
      },
      // View
      {
        path: '/view/',
        title: "View"
      },
      {
        path: '/view/sidebar',
        title: "Sidebar",
        checked: application.store.showSidebar,
        action: function() {
          application.store.showSidebar = !application.store.showSidebar;
        }
      },
      // Help
      {
        path: '/help/',
        title: "Help"
      }
    ]
  }

  Window {
    id: root

    visible: true
    windowWidth: 500
    windowHeight: 300
    type: Window.WindowType.AppWindow
    title: Pouch.basename(Pouch.pwd) + " - Pouch"

    menu: application.mainMenu
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
      ToolbarItem {
        label: 'debug(' + DesktopEnvironment.pixelsPerDp + ')'
        SegmentedControl {
          trackingMode: SegmentedControl.TrackingMode.Momentary
          Segment {
            label: '-'
          }
          Segment {
            label: '+'
          }

          onSelected: {
            if (index === 0) {
              DesktopEnvironment._debugFunction(-0.25);
            } else if (index === 1) {
              DesktopEnvironment._debugFunction(0.25);
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

        ColumnLayout {
          anchors.left: parent.left
          anchors.right: parent.right
          spacing: 0
          SidebarItem {
            title: "Home"
            icon: DesktopEnvironment.icons.goHome
            path: "/home/user"
          }
          SidebarItem {
            title: "Documents"
            icon: DesktopEnvironment.icons.emblemDocuments
            path: "/home/user/Documents"
          }
          SidebarItem {
            title: "Downloads"
            icon: DesktopEnvironment.icons.emblemDownloads
            path: "/home/user/Downloads"
          }
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
        Button {
          width: 100
          height: 50
          x: 200
          title: "Hide"
          onClicked: {
            sidebar.visible = false;
            print('hello?? ' + root);
            print(Pouch.pwd);
          }
        }
        ScrollView {
          x: 300
          width: 100
//          height: 170
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          Rectangle {
            width: 100
            height: 150
            color: "black"
          }
          Rectangle {
            y: 150
            width: 80
            height: 150
            color: "red"
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

    Alert {
      id: alert
      modality: Qt.WindowModal //Qt.ApplicationModal

      message: 'Hello'
      informativeText: '𝄞Are you sure to delete \'File\' permanently?🙍🏿‍♀️'

      onOk: {
        print('Ok clicked.');
      }
    }
  } // Window

  Component.onCompleted: {
    DesktopEnvironment.app.mainMenu = application.mainMenu;
    root.show();
  }
}
