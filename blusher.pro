QT = gui quick quickwidgets
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS \
    BL_BUILDING

TEMPLATE = lib

VERSION = 0.1.0

INCLUDEPATH += ./include

SOURCES += src/cpp/blusher_plugin.cpp \
    src/cpp/Anchors.cpp \
    src/cpp/BaseWindow.cpp \
    src/cpp/Blusher.cpp \
    src/cpp/Box.cpp \
    src/cpp/DesktopEnvironment.cpp \
    src/cpp/Ewmh.cpp \
    src/cpp/HydrogenStyle.cpp \
    src/cpp/KeyEvent.cpp \
    src/cpp/Menu.cpp \
    src/cpp/MenuItem.cpp \
    src/cpp/MenuView.cpp \
    src/cpp/ScreenInfo.cpp \
    src/cpp/View.cpp

HEADERS += src/cpp/blusher_plugin.h \
    src/cpp/Anchors.h \
    src/cpp/BaseWindow.h \
    src/cpp/Blusher.h \
    src/cpp/Box.h \
    src/cpp/DesktopEnvironment.h \
    src/cpp/Ewmh.h \
    src/cpp/HydrogenStyle.h \
    src/cpp/KeyEvent.h \
    src/cpp/Menu.h \
    src/cpp/MenuItem.h \
    src/cpp/MenuView.h \
    src/cpp/ScreenInfo.h \
    src/cpp/View.h

RESOURCES = resources/resources.qrc

TARGET = blusher
# blusher.dll rather than blusher{X}.dll
win32: CONFIG += skip_target_version_ext

DISTFILES += \
    include/blusher/base.h \
    include/blusher/blusher.h \
    include/blusher/Application.h \
    lib/blusher/qml/Blusher/Checkbox.qml \
    lib/blusher/qml/Blusher/Slider.qml \
    lib/blusher/qml/Blusher/Tab.qml \
    lib/blusher/qml/Blusher/TabView.qml \
    lib/blusher/qml/Blusher/Window.qml \
    lib/blusher/qml/Blusher/Button.qml \
    lib/blusher/qml/Blusher/Label.qml \
    lib/blusher/qml/Blusher/MenuBar.qml \
    lib/blusher/qml/Blusher/ScrollView.qml \
    lib/blusher/qml/Blusher/Toolbar.qml \
    lib/blusher/qml/Blusher/ToolbarItem.qml \
    lib/blusher/qml/Blusher/DesktopEnvironment/DesktopEnvironment.qml \
    lib/blusher/qml/Blusher/Standalone/DesktopEnvironmentModule/qmldir \
    lib/blusher/qml/Blusher/Standalone/DesktopEnvironmentModule/DesktopEnvironmentModule.qml \
    lib/blusher/qml/Blusher/Standalone/DesktopEnvironmentModule/Formatter.qml \
    lib/blusher/qml/Blusher/plugins.qmltypes \
    lib/blusher/qml/Blusher/qmldir

