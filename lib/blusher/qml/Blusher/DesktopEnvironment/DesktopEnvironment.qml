pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

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
      model: overlayLoader.menus.length
      Loader {
        sourceComponent: root.menuDelegate

        Component.onCompleted: {
          this.item.menu = overlayLoader.menus[index]
          this.x = root.parent.Window.window.x + (index * 100)
          this.y = root.parent.Window.window.y + 30
        }

        onVisibleChanged: {
          if (this.visible === false) {
            root._popMenu()
          }
        }
      }
    }
  }

  // Overlay component
  Component {
    id: overlayComponent
    QtQuickWindow.Window {
      id: _window

      property alias overlayItemLoader: overlayItemLoader

      visible: true
      flags: Qt.Popup
      color: "#11330000" // "#00000000"

      MouseArea {
        anchors.fill: parent

        onClicked: {
          root.menuClosed()
        }

        MouseArea {
          id: _menuBarArea
          hoverEnabled: true
          propagateComposedEvents: true
          height: 30

          Loader {
            id: _menuBarLoader

            onLoaded: {
              overlayLoader.menuBarMenu = root.parent.Window.window.menu;
            }
          }
        }

        Loader {
          id: overlayItemLoader
        }
      }

      Component.onCompleted: {
        this.width = QtQuickWindow.Screen.width
        this.height = QtQuickWindow.Screen.height

        _menuBarArea.x = root.parent.Window.window.x
        _menuBarArea.y = root.parent.Window.window.y
        _menuBarArea.width = root.parent.Window.window.width

        if (_menuBarLoader.sourceComponent !== undefined) {
          _menuBarLoader.sourceComponent = undefined;
        }
        _menuBarLoader.sourceComponent = root.menuDelegate;
        _menuBarLoader.item.menu = overlayLoader.menuBarMenu;
      }
    }
  }

  // Debug panel component
  Component {
    id: debugPanelComponent
    QtQuickWindow.Window {
      id: _debugPanel
      flags: Qt.Popup

      width: 300
      height: 300
      visible: true

      color: "#000000"
      Repeater {
        model: [
          'menuOpen: ' + root.menuOpen,
          'menuBarMenu: ' + overlayLoader.menuBarMenu,
          '  - focusedItemIndex: ' + (overlayLoader.menuBarMenu ? overlayLoader.menuBarMenu.focusedItemIndex : 'none'),
          'overlayLoader.menus: ' + overlayLoader.menus,
          '  - length: ' + overlayLoader.menus.length,
          '  - last menu: ' + ((overlayLoader.menus.length > 0) ? overlayLoader.menus[overlayLoader.menus.length - 1].title : 'none'),
          'applicationMenu',
          '  - opened: ' + root.menus.applicationMenu.opened
        ]
        Text {
          y: index * 16
          text: modelData
          color: "white"
        }
      }
    }
  }

  //================
  // Items
  //================

  Loader {
    id: overlayLoader
    property list<Menu> menus
    property Menu menuBarMenu

    onMenusChanged: {
      const overlayItemLoader = root.overlay.overlayItemLoader

      overlayItemLoader.sourceComponent = undefined
      overlayItemLoader.sourceComponent = menuViewComponent

      overlayItemLoader.item.x = root.parent.Window.window.x
      overlayItemLoader.item.y = root.parent.Window.window.y + 30
    }
  }

  Loader {
    id: debugPanelLoader
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
        overlayLoader.sourceComponent = overlayComponent
      }
      root.overlay.visible = true

      // Give global focus to the root window.
      root.parent.Window.window.giveGlobalFocus()
    } else {
      if (menu === DesktopEnvironment.menus.applicationMenu ||
        menu.supermenu.type === Menu.MenuType.MenuBarMenu) {
        overlayLoader.menus = [];
      } else {
        const lastOpenedMenu = overlayLoader.menus[overlayLoader.menus.length - 1];
        if (menu.supermenu === lastOpenedMenu) {
        } else if (root._isMenuDescendantOf(lastOpenedMenu, menu.supermenu)) {
          root._popMenu();
        }
      }
    }
    overlayLoader.menus.push(menu);
    internal.menuOpen = true
  }
  onMenuClosed: {
    for (let i = overlayLoader.menus.length - 1; i >= 0; --i) {
      overlayLoader.menus[i].close()
    }
    overlayLoader.menus = [];
    if (overlayLoader.menuBarMenu) {
      overlayLoader.menuBarMenu.focusItem(-1);
    }

    root.overlay.visible = false
    internal.menuOpen = false
  }

  Component.onCompleted: {
    print('[DesktopEnvironment.onCompleted]')
    root._initDesktopEnvironmentModule();

    if (Process.env.BLUSHER_DEBUG === true) {
      print('[DesktopEnvironment] BLUSHER_DEBUG is on.');
      debugPanelLoader.sourceComponent = debugPanelComponent;
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
    for (let i = 0; i < overlayLoader.menus.length - 1; ++i) {
      newMenus.push(overlayLoader.menus[i])
    }
    overlayLoader.menus = newMenus
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
      //
    }

    internal.menuDelegate = deModule.menuDelegate;

    // Setup signal handlers.
    internal.onAppCursorChanged = deModule.onAppCursorChanged;

    // Setup app object.
    internal.appName = Process.env.BLUSHER_APP_NAME;
    internal.appVersion = Process.env.BLUSHER_APP_VERSION;
  }

  //================================
  // Standalone implementations
  //================================

  // Standalone desktop environment module.
  QtObject {
    id: standalone

    property var menuDelegate: standaloneMenuDelegate
    property var menuItemDelegate: null

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
