import Blusher 0.1
import Blusher.DesktopEnvironment 0.1
//import QtQuick.Window 2.12
import QtQuick 2.12

Window {
  id: root

  title: 'Scratcher'
  visible: true
  width: 400
  height: 400

  menu: Menu {
    title: 'Application Menu'
    type: Menu.MenuType.MenuBarMenu
    MenuItem {
      title: 'File'
      submenu: Menu {
        title: 'File'
        type: Menu.MenuType.Submenu
        MenuItem {
          title: 'Quit'
        }
      }
    }
    MenuItem {
      title: 'Edit'
      submenu: Menu {
        title: 'Edit'
        MenuItem {
          title: 'Copy'
        }
        MenuItem {
          title: 'Paste'
        }
        MenuItem {
          separator: true
        }
        MenuItem {
          title: 'Select All'
        }
      }
    }
    MenuItem {
      title: 'View'
      submenu: Menu {
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
      print(Process.app);
      print(Blusher);
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
      id: checboxAll
      title: 'Check All'
      checkState: getState()
      customCheckFunction: true

      onClicked: {
        if (this.checkState === Checkbox.CheckState.Unchecked ||
            this.checkState === Checkbox.CheckState.Mixed) {
          checkbox1.checkState = Checkbox.CheckState.Checked;
          checkbox2.checkState = Checkbox.CheckState.Checked;
        } else {
          checkbox1.checkState = Checkbox.CheckState.Unchecked;
          checkbox2.checkState = Checkbox.CheckState.Unchecked;
        }
      }
      function getState() {
        if (checkbox1.checkState === Checkbox.CheckState.Checked &&
            checkbox2.checkState === Checkbox.CheckState.Checked) {
          return Checkbox.CheckState.Checked;
        } else if (checkbox1.checkState === Checkbox.CheckState.Unchecked &&
            checkbox2.checkState === Checkbox.CheckState.Unchecked) {
          return Checkbox.CheckState.Unchecked;
        } else {
          return Checkbox.CheckState.Mixed;
        }
      }
    }
    Column {
      x: 30
      y: 30
      Checkbox {
        id: checkbox1
        title: 'Check 1'
      }
      Checkbox {
        id: checkbox2
        title: 'Check 2'
      }
    }
  }

  Menu {
    id: testMenu
    type: Menu.MenuType.ContextualMenu
    title: 'Test Menu'
    MenuItem {
      id: test
      title: "Hello"
    }
    MenuItem {
      title: "World"
      onTriggered: {
        print("Hello, world!");
      }
    }
    MenuItem {
      separator: true
    }
    MenuItem {
      title: "Open..."
      submenu: Menu {
        title: "Open"
        type: Menu.MenuType.Submenu
        MenuItem {
          title: "from file"
        }
        MenuItem {
          title: "recent"
        }
        MenuItem {
          title: "Submenu Test"
          submenu: Menu {
            title: "Submenu Test"
            type: Menu.MenuType.Submenu
          }
        }
      }
    }

    Component.onCompleted: {
      this.addItem(test);
    }
  }
}
