import Blusher 0.1
import Blusher.DesktopEnvironment 0.1
//import QtQuick.Window 2.12
import QtQuick 2.12

Window3 {
  id: root

  title: 'Scratcher'
  visible: true
  width: 300
  height: 300

  menu: Menu2 {
    title: 'Application Menu'
    type: Menu2.MenuBarMenu
    MenuItem2 {
      title: 'File'
      submenu: Menu2 {
        title: 'File'
        type: Menu2.Submenu
        MenuItem2 {
          title: 'Quit'
        }
      }
    }
    MenuItem2 {
      title: 'Edit'
      submenu: Menu2 {
        title: 'Edit'
        MenuItem2 {
          title: 'Copy'
        }
        MenuItem2 {
          title: 'Paste'
        }
      }
    }
    MenuItem2 {
      title: 'View'
      submenu: Menu2 {
        title: 'View'
      }
    }
  }

  View {
    anchors.fill: parent
    MouseArea {
      anchors.fill: parent
      onClicked: {
        print(Object.keys(DesktopEnvironmentPlugin.screens));
        DesktopEnvironmentPlugin.screenInfoChanged("foo", "bar", "baz");
      }
    }
  }

  Button {
    title: 'Button'
    onClicked: {
      print('Button clicked!');
      print(Blusher.app);
      print(Object.keys(DesktopEnvironment.screens));
      print(root.screenName);
      print(Process.env.BLUSHER_APP_NAME);
      testMenu.open();
    }
  }

  Menu2 {
    id: testMenu
    MenuItem2 {
      id: test
      title: "Hello"
    }
    MenuItem2 {
      title: "World"
      onTriggered: {
        print("Hello, world!");
      }
    }
    MenuItem2 {
      title: "Open..."
      submenu: Menu2 {
        title: "Open"
        MenuItem2 {
          title: "from file"
        }
        MenuItem2 {
          title: "recent"
        }
      }
    }

    Component.onCompleted: {
      this.addItem(test);
    }
  }
}
