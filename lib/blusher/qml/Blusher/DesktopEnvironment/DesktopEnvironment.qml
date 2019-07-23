pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12

import ".."
import "Standalone" as Standalone

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
  readonly property alias pixelsPerDp: internal.pixelsPerDp
  readonly property alias app: internal.app
  readonly property alias menuDelegate: internal.menuDelegate
  readonly property alias menuBarHeight: internal.menuBarHeight

  // States
  readonly property alias menuOpen: internal.menuOpen

  // References
  property alias overlay: overlayLoader.item

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

    property string appName: ""
    property string appVersion: ""

    property var onAppCursorChanged: function(cursor) {}
    property var app: QtObject {
      readonly property alias name: internal.appName
      property string displayName: ""
      readonly property alias version: internal.appVersion
      property int cursor: DesktopEnvironment.Cursor.Auto

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
      title: "Application"
      MenuItem {
        title: "Preferences..."
      }

      MenuItem {
        title: "Quit"
        action: DesktopEnvironment.app.quit
        shortcut: DesktopEnvironment.KeyModifier.Control | Qt.Key_Q
      }
    }
    property Menu textEditMenu: Menu {
      type: Menu.MenuType.ContextualMenu
      title: "Text"
      MenuItem {
        title: "Copy"
      }
      MenuItem {
        title: "Paste"
      }
    }
  }

  //==================
  // Signals
  //==================

  /// \brief  Sould emitted when the menu is opening.
  signal menuOpened(Item parent, ListModel menu)
  /// \brief  Should emitted when all menus are completely closed.
  signal menuClosed()

  //===================
  // Components
  //===================

  // MenuView component
  Component {
    id: menuViewComponent
    Repeater {
      model: root.overlay.menus.length
      delegate: Standalone.PopUpMenuDelegate {
        menu: root.overlay.menus[index]
      }

      onItemAdded: {
        if (item.menu.supermenu === null &&
            item.menu.type === Menu.MenuType.ContextualMenu) {
          item.x = root.overlay.mouseX + 1;
          item.y = root.overlay.mouseY;
        } else if (item.menu === DesktopEnvironment.menus.applicationMenu ||
            item.menu.supermenu.type === Menu.MenuType.MenuBarMenu) {
          item.x = root.parent.Window.window.x;
          item.y = root.parent.Window.window.y + (30 * DesktopEnvironment.pixelsPerDp);
        } else {
          const parentMenuDelegate = this.itemAt(index - 1);
          item.x = parentMenuDelegate.x + parentMenuDelegate.width + 1;
          item.y = parentMenuDelegate.y;
        }
      }
    }
  }

  //================
  // Items
  //================

  Loader {
    id: overlayLoader
  }

  Loader {
    id: debugPanelLoader
  }

  Loader {
    id: deModuleLoader
  }

  //==========================
  // Signal handlers
  //==========================

  onMenuOpened: {
    if (!this.menuOpen) {
      // Set singleton item child of root window.
      // It is important to refer the geometry of root window such as x and y.
      root.parent = parent
      // Load if not loaded yet.
      if (!overlayLoader.sourceComponent) {
        overlayLoader.setSource('./Standalone/Overlay.qml');
      }
      root.overlay.visible = true
    } else {
      if (menu === DesktopEnvironment.menus.applicationMenu ||
        menu.supermenu.type === Menu.MenuType.MenuBarMenu) {
        for (let i = root.overlay.menus.length - 1; i >= 0; --i) {
          root._popMenu();
        }
      } else {
        const lastOpenedMenu = root.overlay.menus[root.overlay.menus.length - 1];
        if (menu.supermenu === lastOpenedMenu) {
        } else if (root._isMenuDescendantOf(lastOpenedMenu, menu.supermenu)) {
          root._popMenu();
        }
      }
    }
    root.overlay.menus.push(menu);
    internal.menuOpen = true
  }
  onMenuClosed: {
    for (let i = root.overlay.menus.length - 1; i >= 0; --i) {
      root.overlay.menus[i].close();
    }
    root.overlay.menus = [];
    if (root.overlay.menuBarMenu) {
      root.overlay.menuBarMenu.focusItem(-1);
    }

    root.overlay.visible = false
    internal.menuOpen = false
  }

  Component.onCompleted: {
    print('[DesktopEnvironment.onCompleted]')
    root._initDesktopEnvironmentModule();

    if (Process.env.BLUSHER_DEBUG === true) {
      print('[DesktopEnvironment] BLUSHER_DEBUG is on.');
      debugPanelLoader.setSource('./Standalone/DebugPanel.qml');
    }
  }

  Component.onDestruction: {
    print('[DesktopEnvironment.onDestruction]')
    overlayLoader.sourceComponent = undefined
  }

  //=============
  // Methods
  //=============

  // Public methods
  function shortcutToString(shortcut) {
    let text = '';
    const modifiers = shortcut & 0xff000000;
    const key = shortcut & 0x00ffffff;

    if (modifiers === DesktopEnvironment.KeyModifier.Shift) {
      text += 'Shift';
    } else if (modifiers === DesktopEnvironment.KeyModifier.Control) {
      text += 'Ctrl';
    }

    switch (key) {
    case Qt.Key_A:
      text += '+A';
      break;
    case Qt.Key_B:
      text += '+B';
      break;
    case Qt.Key_C:
      text += '+C';
      break;
    case Qt.Key_D:
      text += '+D';
      break;
    case Qt.Key_E:
      text += '+E';
      break;
    case Qt.Key_F:
      text += '+F';
      break;
    case Qt.Key_G:
      text += '+G';
      break;
    case Qt.Key_H:
      text += '+H';
      break;
    case Qt.Key_I:
      text += '+I';
      break;
    case Qt.Key_J:
      text += '+J';
      break;
    case Qt.Key_K:
      text += '+K';
      break;
    case Qt.Key_L:
      text += '+L';
      break;
    case Qt.Key_M:
      text += '+M';
      break;
    case Qt.Key_N:
      text += '+N';
      break;
    case Qt.Key_O:
      text += '+O';
      break;
    case Qt.Key_P:
      text += '+P';
      break;
    case Qt.Key_Q:
      text += '+Q';
      break;
    case Qt.Key_R:
      text += '+R';
      break;
    case Qt.Key_S:
      text += '+S';
      break;
    case Qt.Key_T:
      text += '+T';
      break;
    case Qt.Key_U:
      text += '+U';
      break;
    case Qt.Key_V:
      text += '+V';
      break;
    case Qt.Key_W:
      text += '+W';
      break;
    case Qt.Key_X:
      text += '+X';
      break;
    case Qt.Key_Y:
      text += '+Y';
      break;
    case Qt.Key_Z:
      text += '+Z';
      break;
    default:
      break;
    }

    return text;
  }

  // Private methods
  function _openSubmenu(menu) {
    const prevMenu = overlayLoader.menus[overlayLoader.menus.length -1]
  }

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

    print('[DesktopEnvironment._initDesktopEnvironmentModule] dePath: ' + dePath);
    if (dePath === '') {
      deModule = standalone;
    } else {
      deModule = standalone;
      deModuleLoader.setSource(dePath + '/DesktopEnvironmentModule/DesktopEnvironmentModule.qml');
    }

    internal.menuDelegate = deModule.menuDelegate;

    internal.menuBarHeight = deModule.menuBarHeight;

    // Setup signal handlers.
    internal.onAppCursorChanged = deModule.onAppCursorChanged;

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

    property var menuDelegate: standaloneMenuDelegate
    property var menuItemDelegate: null

    property int menuBarHeight: 30

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
  }

  // Standalone menu delegate component.
  Component {
    id: standaloneMenuDelegate
    Item {
      id: root

      //===================
      // Public properties
      //===================
      property Menu menu: null

      Loader {
        id: _loader
      }

      onMenuChanged: {
        if (root.menu.type === Menu.MenuType.MenuBarMenu) {
          _loader.setSource('Standalone/MenuBarMenuDelegate.qml', { 'menu': root.menu });
        } else {
          _loader.setSource('Standalone/PopUpMenuDelegate.qml', { 'menu': root.menu });
        }
      }
    }
  }
}
