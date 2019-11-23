import Blusher 0.1
//import QtQuick.Window 2.12
import QtQuick 2.12

Window3 {
  title: 'Scratcher'
  visible: true
  width: 300
  height: 300

  View {
    anchors.fill: parent
    MouseArea {
      anchors.fill: parent
      onClicked: {
        print('hello!');
        print(Object.keys(DesktopEnvironmentPlugin.screens));
        DesktopEnvironmentPlugin.screenInfoChanged("foo", "bar", "baz");
      }
    }
  }

  Button {
    title: 'Click me'
  }
}
