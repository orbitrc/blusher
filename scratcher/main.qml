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
        print(Object.keys(DesktopEnvironmentPlugin.screens));
        DesktopEnvironmentPlugin.screenInfoChanged("foo", "bar", "baz");
        print(Window3.WindowType.AppWindow);
      }
    }
  }

  Button {
    title: 'Click me'
  }
}
