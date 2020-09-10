pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12

//import ".."
import Blusher 0.1
import DesktopEnvironmentModule 0.1

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
  readonly property string name: internal.name
  property var screens: DesktopEnvironmentPlugin.screens  // Need binding to change signal?
  readonly property alias pixelsPerDp: internal.pixelsPerDp
  readonly property alias app: internal.app

  readonly property alias shortcutToString: internal.shortcutToString

  // States
  readonly property alias menuOpen: internal.menuOpen

  // References
//  property alias standaloneDeModule: standalone

  //====================
  // Private Properties
  //====================
  QtObject {
    id: internal
    property string name: 'standalone'

    property bool menuOpen: false
    property real pixelsPerDp: 1

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

  function _initDesktopEnvironmentModule() {
    const dePath = Process.env.BLUSHER_DE_MODULE_PATH;
    print('[DesktopEnvironment._initDesktopEnvironmentModule] dePath: ' + dePath);

    // Setup basic informations.
    internal.name = DesktopEnvironmentModule.name;

    // Setup signal handlers.
    internal.onAppCursorChanged = DesktopEnvironmentModule.onAppCursorChanged;

    // Setup public methods.
    internal.shortcutToString = DesktopEnvironmentModule.shortcutToString;

    // Setup app object.
    internal.appName = Process.env.BLUSHER_APP_NAME;
    internal.appVersion = Process.env.BLUSHER_APP_VERSION;
  }

  function _debugFunction(payload) {
    internal.pixelsPerDp += payload;
  }
}
