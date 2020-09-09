pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12

//import ".."
import Blusher 0.1
import "Standalone" as Standalone
import Blusher.DesktopEnvironment.Standalone 0.1

Item {
  id: root

  enum Cursor {
    Auto,
    Arrow,
    Pointer,
    IBeam,
    ResizeLeftRight,
    ResizeUpDown
  }

  enum KeyModifier {
    None    = 0x00000000, // 00000000 00000000 00000000 00000000
    Shift   = 0x01000000, // 00000001 00000000 00000000 00000000
    Control = 0x02000000, // 00000010 00000000 00000000 00000000
    Alt     = 0x04000000, // 00000100 00000000 00000000 00000000
    Super   = 0x08000000  // 00001000 00000000 00000000 00000000
  }

  //===================
  // Properties
  //===================
  property string name: "standalone"
  property var screens: DesktopEnvironmentPlugin.screens  // Need binding to change signal?
  readonly property alias pixelsPerDp: internal.pixelsPerDp
  readonly property alias app: internal.app
  readonly property alias menuDelegate: internal.menuDelegate
  readonly property alias menuBarHeight: internal.menuBarHeight

  readonly property alias shortcutToString: internal.shortcutToString

  readonly property alias onMenuOpened: internal.onMenuOpened
  readonly property alias onMenuClosed: internal.onMenuClosed

  // States
  readonly property alias menuOpen: internal.menuOpen

  // References
  property alias standaloneDeModule: standalone

  //====================
  // Private Properties
  //====================
  QtObject {
    id: internal
    property bool menuOpen: false
    property real pixelsPerDp: 1

    property var menuDelegate: null
    property var menuItemDelegate: null

    property int menuBarHeight: 0

    property var onMenuOpened: function(menu) {}
    property var onMenuClosed: function() {}
    property var shortcutToString: function(shortcut) {}


    property string appName: ""
    property string appVersion: ""

    property var onAppCursorChanged: function(cursor) {}
    property var app: QtObject {
      readonly property alias name: internal.appName
      property string displayName: ""
      readonly property alias version: internal.appVersion
      property int cursor: DesktopEnvironment.Cursor.Auto
      property Window activeWindow: null
      property Menu mainMenu: Menu {
        title: 'Main Menu'
        type: Menu.MenuType.MenuBarMenu
      }

      // Methods
      function quit() { Qt.exit(0); }

      onCursorChanged: {
        internal.onAppCursorChanged(this.cursor);
      }
    }
  }

  //===================
  // Constants
  //===================
  property alias icons: _icons
  property alias fonts: _fonts
  property alias menus: _menus
  QtObject {
    id: _icons
    property string theme: "standalone"
    property Image goPrevious: Image {
      source: "../../../icons/standalone/scalable/actions/go-previous.svg"
    }
    property Image goNext: Image {
      source: "../../../icons/standalone/scalable/actions/go-next.svg"
    }

    property Image goHome: Image {
      source: "../../../icons/standalone/scalable/actions/go-home.svg"
    }
    property Image emblemDocuments: Image {
      source: "../../../icons/standalone/scalable/emblems/emblem-documents.svg"
    }
    property Image emblemDownloads: Image {
      source: "../../../icons/standalone/scalable/emblems/emblem-downloads.svg"
    }

    // Non-standard icons.
    property Image checked: Image {
      source: "../../../icons/standalone/scalable/status/checked.svg"
    }
  }
  QtObject {
    id: _fonts
    property int x11DotsPerInch: 72   // Used only on X Window System.
  }
  QtObject {
    id: _menus
    property Menu applicationMenu: Menu {
      type: Menu.MenuType.Submenu
      title: 'Application'
      MenuItem {
        title: "Preferences..."
      }

      MenuItem {
        title: "Quit"
//        action: DesktopEnvironment.app.quit
        shortcut: DesktopEnvironment.KeyModifier.Control | Qt.Key_Q
      }
    }
    property Menu textEditMenu: Menu {
      type: Menu.MenuType.ContextualMenu
      title: "Text"
      MenuItem {
        title: 'Copy'
      }
      MenuItem {
        title: 'Paste'
      }
    }
  }

  //==================
  // Signals
  //==================
  signal menuItemTriggered(string path)

  //===================
  // Components
  //===================

  //================
  // Loaders
  //================
  Loader {
    id: deModuleLoader
  }

  //==========================
  // Signal handlers
  //==========================

  Component.onCompleted: {
    print('[DesktopEnvironment.onCompleted]')
    root._initDesktopEnvironmentModule();

    if (Process.env.BLUSHER_DEBUG === true) {
      print('[DesktopEnvironment] BLUSHER_DEBUG=true');
      print('[DesktopEnvironment] BLUSHER_APP_NAME="' + Process.env.BLUSHER_APP_NAME + '"');
      print('[DesktopEnvironment] BLUSHER_APP_VERSION="' + Process.env.BLUSHER_APP_VERSION + '"');
    }
  }

  Component.onDestruction: {
    print('[DesktopEnvironment.onDestruction]')
  }

  //=============
  // Methods
  //=============

  // Private methods
  function _popMenu() {
    let newMenus = []
    root.overlay.menus[root.overlay.menus.length - 1].close();
    for (let i = 0; i < root.overlay.menus.length - 1; ++i) {
      newMenus.push(root.overlay.menus[i]);
    }
    root.overlay.menus = newMenus;
  }

  function _isMenuDescendantOf(menu, target) {
    let it = menu;
    while (it !== null) {
      if (it === target) {
        return true;
      }
      it = it.supermenu;
    }

    return false;
  }

  function _initDesktopEnvironmentModule() {
    const dePath = Process.env.BLUSHER_DE_MODULE_PATH;
    let deModule = null;

    if (dePath === '') {
      deModule = standalone;
    } else {
      print('[DesktopEnvironment._initDesktopEnvironmentModule] dePath: ' + dePath);
      deModuleLoader.setSource(dePath + '/DesktopEnvironmentModule/DesktopEnvironmentModule.qml');
      deModule = deModuleLoader.item;
    }

    // Setup signal handlers.
    internal.onAppCursorChanged = deModule.onAppCursorChanged;
    internal.onMenuOpened = deModule.onMenuOpened;
    internal.onMenuClosed = deModule.onMenuClosed;

    // Setup public methods.
    internal.shortcutToString = deModule.shortcutToString;

    // Setup app object.
    internal.appName = Process.env.BLUSHER_APP_NAME;
    internal.appVersion = Process.env.BLUSHER_APP_VERSION;
  }

  function _debugFunction(payload) {
    internal.pixelsPerDp += payload;
  }

  //================================
  // Standalone implementations
  //================================

  // Standalone desktop environment module.
  QtObject {
    id: standalone

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
}
