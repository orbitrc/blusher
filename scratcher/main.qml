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

//  menu: Menu {
//    title: 'Application Menu'
//    MenuItem {
//      title: 'File'
//      submenu: Menu {
//        title: 'Quit'
//      }
//    }
//  }
  menu: 'menu'

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
    }
    Menu2 {
      QtObject {
        id: test
      }
      Component.onCompleted: {
        this.addItem(test);
      }
    }
  }

}
