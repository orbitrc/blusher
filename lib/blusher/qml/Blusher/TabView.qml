import QtQuick 2.12

import Blusher 0.1

View {
  id: root

  default property list<Tab> tabs

  property int _currentTabIndex: -1

  Box {
    id: rect

    anchors.bottom: root.bottom
    anchors.left: root.left

    width: root.width
    height: root.height - 10

    radius: 5
    borderWidth: 1
    borderColor: '#000000'
  }

  View {
    id: tabGroup

    anchors.horizontalCenter: root.horizontalCenter

    scaleWidth: false
    width: childrenRect.width
    height: 20

    Flow {
      spacing: -1

      Repeater {
        model: root.tabs
        Box {
          scaleWidth: false
          width: tabTitle.implicitWidth + (12 * (root.window ? root.window.screenScale : 1))
          height: 20
          topLeftRadius: firstTab() ? 6 : 0
          bottomLeftRadius: firstTab() ? 6 : 0
          topRightRadius: lastTab() ? 6 : 0
          bottomRightRadius: lastTab() ? 6 : 0
          borderWidth: 1
          borderColor: '#000000'

          function firstTab() {
            return index === 0 ? true : false;
          }
          function lastTab() {
            return index === root.tabs.length - 1 ? true : false;
          }

          Text {
            id: tabTitle

            anchors.centerIn: parent

            text: root.tabs[index].title
            font.pixelSize: 12 * (root.window ? root.window.screenScale : 1)
          }

          MouseArea {
            anchors.fill: parent

            onClicked: {
              // Unload current component.
              if (root._currentTabIndex !== -1) {
                root.tabs[root._currentTabIndex].sourceComponent = undefined;
                root.tabs[root._currentTabIndex].parent = null;
              }
              // Load component.
              root.tabs[index].sourceComponent = root.tabs[index].component;
              root._currentTabIndex = index;
              root.tabs[index].parent = rect;
            }
          }
        }
      }
    }
  }
}
