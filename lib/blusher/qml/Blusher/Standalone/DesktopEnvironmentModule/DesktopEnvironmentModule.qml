pragma Singleton
import QtQuick 2.12

QtObject {
  id: standalone

  property string name: 'standalone'

  property int pixelsPerDp: 1

  property int decorationTopHeight: 0
  property int decorationBottomHeight: 0
  property int decorationLeftWidth: 0
  property int decorationRightWidth: 0

  function onAppCursorChanged(cursor) {
    switch (cursor) {
    case DesktopEnvironment.Auto:
      Process.app.objectName = "BLUSHER_CURSOR_AUTO";
      break;
    case DesktopEnvironment.ResizeLeftRight:
      Process.app.objectName = "BLUSHER_CURSOR_RESIZE_LEFT_RIGHT";
      break;

    case DesktopEnvironment.ResizeUpDown:
      Process.app.objectName = "BLUSHER_CURSOR_RESIZE_UP_DOWN";
      break;
    default:
      break;
    }
  }

  function shortcutToString(shortcut) {
    return Formatter.shortcutToString(shortcut);
  }
}
