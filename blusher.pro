QT = gui quick widgets
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS \
    BL_BUILDING

TEMPLATE = lib

VERSION = 0.1.0

INCLUDEPATH += ./include

SOURCES += src/cpp/blusher_plugin.cpp \
    src/Application.cpp \
#    src/cpp/Application_bridge.cpp \
    src/cpp/BaseWindow.cpp \
    src/cpp/Blusher.cpp \
    src/cpp/DesktopEnvironment.cpp \
    src/cpp/HydrogenStyle.cpp \
    src/cpp/KeyEvent.cpp \
    src/cpp/Menu.cpp \
    src/cpp/MenuItem.cpp \
    src/cpp/MenuView.cpp \
    src/cpp/View.cpp

HEADERS += src/cpp/blusher_plugin.h \
    include/blusher.h \
    include/blusher/Application.h \
#    src/Application_bridge.h \
#    include/blusher/blusher-qt.h \
    include/blusher/blusher_base.h \
    src/cpp/BaseWindow.h \
    src/cpp/Blusher.h \
    src/cpp/DesktopEnvironment.h \
    src/cpp/HydrogenStyle.h \
    src/cpp/KeyEvent.h \
    src/cpp/Menu.h \
    src/cpp/MenuItem.h \
    src/cpp/MenuView.h \
    src/cpp/View.h

TARGET = blusher
# blusher.dll rather than blusher{X}.dll
win32: CONFIG += skip_target_version_ext

DISTFILES += \
    lib/blusher/qml/Blusher/Checkbox.qml \
    lib/blusher/qml/Blusher/Window3.qml \
    lib/blusher/qml/Blusher/Button.qml \
    lib/blusher/qml/Blusher/Label.qml \
    lib/blusher/qml/Blusher/Menu.qml \
    lib/blusher/qml/Blusher/MenuItem.qml \
    lib/blusher/qml/Blusher/MenuBar.qml \
    lib/blusher/qml/Blusher/DesktopEnvironment/DesktopEnvironment.qml \
    lib/blusher/qml/Blusher/plugins.qmltypes \
    lib/blusher/qml/Blusher/qmldir

