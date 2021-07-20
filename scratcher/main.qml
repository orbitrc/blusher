import Blusher 0.1
import Blusher.DesktopEnvironment 0.1
//import QtQuick.Window 2.12
import QtQuick 2.12

Window {
  id: root

  title: 'Scratcher'
  visible: true
  width: 500
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
          onTriggered: {
            print('Quit');
            Qt.quit();
          }
        }
      }
    }
    MenuItem {
      title: 'Edit'
      submenu: Menu {
        type: Menu.MenuType.Submenu
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
        type: Menu.MenuType.Submenu
        title: 'View'
      }
    }
    MenuItem {
      title: 'Help'
    }
  }

  View {
    anchors.fill: parent
    MouseArea {
      anchors.fill: parent
      onClicked: {
        let pos = mapToItem(root.contentItem, mouse.x, mouse.y);
        print('(' + pos.x + ', ' + pos.y + ')');
//        DesktopEnvironmentPlugin.screenInfoChanged("foo", "bar", "baz");
      }
    }
  }

  // Buttons demo.
  Button {
    title: 'Button'
    onClicked: {
      print('Button clicked!');
      print('deModule name: ' + DesktopEnvironment.name);
      print(Process.app);
      print(Blusher);
      print(Object.keys(DesktopEnvironment.screens));
      print(root.screenName);
      print(Process.env.BLUSHER_APP_NAME);
      print(JSON.stringify(DesktopEnvironmentPlugin.screens));
      this.width += 1;
      testMenu.open();
    }
  }

  // Scale demo.
  View {
    x: 120
    width: 400
    height: 100
    Flow {
      anchors.fill: parent

      Button {
        title: '1'
        width: 50
        onClicked: {
          DesktopEnvironmentPlugin.changeScale(DesktopEnvironment.primaryScreen.name, 1);
        }
      }
      Button {
        title: '1.25'
        width: 50
        onClicked: {
          DesktopEnvironmentPlugin.changeScale(DesktopEnvironment.primaryScreen.name, 1.25);
        }
      }
      Button {
        title: '1.5'
        width: 50
        onClicked: {
          DesktopEnvironmentPlugin.changeScale(DesktopEnvironment.primaryScreen.name, 1.5);
        }
      }
      Button {
        title: '2'
        width: 50
        onClicked: {
          DesktopEnvironmentPlugin.changeScale(DesktopEnvironment.primaryScreen.name, 2);
        }
      }
    }
  }


  // Labels demo.
  Label {
    x: 340
    text: '(' + root.x + ', ' + root.y + ') ' + root.width + 'x' + root.height
  }
  Label {
    x: 340
    y: 30
    text: 'Primary Screen: ' + DesktopEnvironment.primaryScreen.x + ', ' + DesktopEnvironment.primaryScreen.y
  }

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

  // Sliders demo.
  Slider {
    id: slider

    x: 20
    y: 100

    start: 0
    end: 200
    step: 1
    value: 50
  }
  Label {
    x: 20
    anchors.top: slider.bottom
    text: slider.value
  }

  TabView {
    id: tabView

    y: 150
    width: 400
    height: 200

    // Windows demo.
    Tab {
      title: 'Windows'

      Component {
        View {
          id: windowsTabView

          Button {
            id: dockWindowButton

            title: 'Dock window'
            onClicked: {
              if (!windowsDemoLoader.sourceComponent) {
                windowsDemoLoader.sourceComponent = dockWindow;
              } else {
                windowsDemoLoader.sourceComponent = undefined;
              }
            }
          }

          Button {
            id: dialogWindowButton

            anchors.top: dockWindowButton.bottom

            title: 'Dialog window'
            onClicked: {
              if (!windowsDemoLoader.sourceComponent) {
                windowsDemoLoader.sourceComponent = dialogWindow;
              } else {
                windowsDemoLoader.sourceComponent = undefined;
              }
            }
          }

          Loader {
            id: windowsDemoLoader
          }
        }
      }
    }
    Tab {
      title: 'Boxes'

      BoxesDemo {
      }
    }
  }

  Component {
    id: dockWindow
    Window {
      visible: true
      netWmWindowType: Window.NetWmWindowType.Dock

      width: 300
      height: 60

      Label {
        text: 'parent: ' + this.parent
      }
    }
  }

  Component {
    id: dialogWindow
    Window {
      visible: true
      netWmWindowType: Window.NetWmWindowType.Dialog
      transientFor: root.windowId

      width: 200
      height: 200

      Label {
        text: 'Dialog window'
      }
      Label {
        y: 30
        text: root.windowId.toString()
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
