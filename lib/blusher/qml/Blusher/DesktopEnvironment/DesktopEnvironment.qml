pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12 as QtQuickWindow
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import ".."

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
    property string msg: "Hi!"
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
  }
  QtObject {
    id: _fonts
    property int x11DotsPerInch: 72   // Used only on X Window System.
  }
  QtObject {
    id: _menus
    property Menu applicationMenu: Menu {
      type: Menu.MenuType.Submenu
      title: DesktopEnvironment.app.name;
      MenuItem {
        title: "Quit"
        action: DesktopEnvironment.app.quit
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
      const lastOpenedMenu = overlayLoader.menus[overlayLoader.menus.length - 1];
      if (menu.supermenu === lastOpenedMenu) {
      } else if (root._isMenuDescendantOf(lastOpenedMenu, menu.supermenu)) {
        root._popMenu();
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
  }

  Component.onDestruction: {
    print('[DesktopEnvironment.onDestruction]')
    overlayLoader.sourceComponent = undefined
  }

  //=============
  // Methods
  //=============

  // Public methods
  function setMsg(text) {
    internal.msg = text
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
    Rectangle {
      id: root

      //===================
      // Public properties
      //===================
      property Menu menu: null

      //================
      // Style
      //================
      implicitHeight: itemsView.implicitHeight
      implicitWidth: itemsView.implicitWidth
      width: this.implicitWidth

      Rectangle {
        id: _menuStyler
        anchors.fill: parent
        color: "#d6d2d0"
        border.width: root.menu.type === Menu.MenuType.MenuBarMenu ? 0 : 1
        border.color: "#ddffffff"
        radius: root.menu.type === Menu.MenuType.MenuBarMenu ? 0 : 3
      }
      DropShadow {
        visible: root.menu.type !== Menu.MenuType.MenuBarMenu
        anchors.fill: _menuStyler
        verticalOffset: 0
        radius: 7.0
        color: "#000000"
        source: _menuStyler
      }

      GridLayout {
        id: itemsView
        property alias menuItemViewList: menuItemViewList

        rows: (root.menu.type === Menu.MenuType.MenuBarMenu) ? 1 : -1
        columns: (root.menu.type !== Menu.MenuType.MenuBarMenu) ? 1 : -1
        rowSpacing: 0
        columnSpacing: 0
        // Menu items
        Repeater {
          model: root.menu
          id: menuItemViewList
          Item {
            implicitWidth: _text.implicitWidth
            height: 30

            Layout.fillWidth: true  // Fill when pop-up menu item.
            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              Rectangle {
                id: _menuItemStyler
                visible: root.menu.items[index].focused
                anchors.fill: parent
                anchors.margins: 2
                border.width: 0
                color: "#bbb4b1"
                radius: 3
              }
              Text {
                id: _text
                text: root.menu.items[index].title
                anchors.verticalCenter: parent.verticalCenter
                rightPadding: 7.0   // 5.0 + styler's margin
                leftPadding: 7.0    // 5.0 + styler's margin
                font.pointSize: 14 * DesktopEnvironment.pixelsPerDp
              }
              Item {
                id: _separator
                visible: false
                height: 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                  height: 1
                  anchors.left: parent.left; anchors.right: parent.right;
                  anchors.top: parent.top
                  border.width: 0
                  gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#00000000"; }
                    GradientStop { position: 0.5; color: "grey"; }
                    GradientStop { position: 1.0; color: "#00000000"; }
                  }
                }
                Rectangle {
                  height: 1
                  anchors.left: parent.left; anchors.right: parent.right;
                  anchors.bottom: parent.bottom
                  border.width: 0
                  gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#00000000"; }
                    GradientStop { position: 0.5; color: "#ffffff"; }
                    GradientStop { position: 1.0; color: "#00000000"; }
                  }
                }
              }

              onClicked: {
                const menuItem = root.menu.items[index];

                // If menu bar menu.
                if (root.menu.type === Menu.MenuType.MenuBarMenu) {
                  if (root.menu.focusedItemIndex > -1) {
                    // Menu bar menu already activated.
                    root.menu.focusItem(-1);
                    DesktopEnvironment.menuClosed()
                  } else {
                    // Menu bar menu not activated before.
                    root.menu.focusItem(index);
                    if (menuItem.hasSubmenu()) {
                      menuItem.submenu.open(Window.window.contentItem)
                    }
                  }
                }
                // If regular menu.
                if (root.menu.type !== Menu.MenuType.MenuBarMenu) {
                  if (!menuItem.hasSubmenu()) {
                    print('MenuItem.action')
                  }
                  if (menuItem.action !== null) {
                    menuItem.action();
                  }
                }
              }

              onEntered: {
                const menuItem = root.menu.items[index];

                if (menuItem.isMenuBarMenuItem()) {
                  root._menuBarMenuItemEntered(index);
                } else {
                  if (menuItem.separator) {
                    root.menu.focusItem(-1);
                  } else {
                    root.menu.focusItem(index);
                  }
                  if (menuItem.hasSubmenu() && !menuItem.submenu.opened) {
                    menuItem.submenu.open(parent)
                  }
                }
              }
              onExited: {
                const menuItem = root.menu.items[index];

                if (menuItem.isMenuBarMenuItem()) {
                  root._menuBarMenuItemExited();
                } else {
                  // If submenu is opened, don't take focus of this item.
                  if (menuItem.hasSubmenu() && menuItem.submenu.opened) {
                    return;
                  }
                  root.menu.focusItem(-1);
                }
              }
            } // MouseArea

            Component.onCompleted: {
              const menuItem = root.menu.items[index];

              if (menuItem.separator) {
                this.Layout.maximumHeight = 10;
                _separator.visible = true
              }
            }
          }
        }
      }


      function _menuBarMenuItemEntered(index) {
        const menuItem = root.menu.items[index];

        // Menu bar menu already activated.
        if (root.menu.focusedItemIndex > -1 && root.menu.focusedItemIndex !== index) {
          root.menu.focusItem(index);
          if (menuItem.hasSubmenu()) {
            menuItem.submenu.open(Window.window.contentItem)
          }
        }
      }

      function _menuBarMenuItemExited(index) {
        const menuItem = root.menu.items[index];

        // Prevent menu bar menu losing focus.
        if (root.menu.focusedItemIndex > -1) {
          return;
        }
      }
    }
  }
}
