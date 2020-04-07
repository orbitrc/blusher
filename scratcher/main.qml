import Blusher 0.1
import Blusher.DesktopEnvironment 0.1
//import QtQuick.Window 2.12
import QtQuick 2.12

Window3 {
  id: root

  title: 'Scratcher'
  visible: true
  width: 400
  height: 400

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
        MenuItem2 {
          separator: true
        }
        MenuItem2 {
          title: 'Select All'
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

  // Buttons demo.
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

  // Labels demo.
  View {
    id: infoArea
    y: 34

    width: 200

    Row {
      Label {
        text: 'Screen name: '
        backgroundColor: 'cyan'
      }
      Label {
        text: root.screenName
        selectable: true
        backgroundColor: 'magenta'
      }
    }
  }

  // Checkboxes demo.
  View {
    id: checkboxArea
    x: infoArea.width
    y: 34

    Checkbox {
      title: 'Check All'

      onClicked: {
        if (this.checkState === Checkbox.CheckState.Unchecked) {
          this.checkState = Checkbox.CheckState.Checked;
        } else {
          this.checkState = Checkbox.CheckState.Unchecked;
        }
      }
    }
  }

  Menu2 {
    id: testMenu
    type: Menu2.MenuType.ContextualMenu
    title: 'Test Menu'
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
      separator: true
    }
    MenuItem2 {
      title: "Open..."
      submenu: Menu2 {
        title: "Open"
        type: Menu2.MenuType.Submenu
        MenuItem2 {
          title: "from file"
        }
        MenuItem2 {
          title: "recent"
        }
        MenuItem2 {
          title: "Submenu Test"
          submenu: Menu2 {
            title: "Submenu Test"
            type: Menu2.MenuType.Submenu
          }
        }
      }
    }

    Component.onCompleted: {
      this.addItem(test);
    }
  }
}
