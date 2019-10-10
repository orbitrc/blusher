import QtQuick 2.12

import "DesktopEnvironment"

Item {
  id: root

  property size size: Qt.size(0, 0)
  property point pos: Qt.point(0, 0)

  width: root.size.width * DesktopEnvironment.pixelsPerDp
  height: root.size.height * DesktopEnvironment.pixelsPerDp
}
