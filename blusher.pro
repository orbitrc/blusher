QT = gui quick
CONFIG += c++11 console

DEFINES += QT_DEPRECATED_WARNINGS

TEMPLATE = lib

VERSION = 0.1.0

SOURCES += src/cpp/blusher_plugin.cpp \
    src/Application.cpp \
    src/cpp/Application_bridge.cpp \
    src/cpp/DesktopEnvironment.cpp \
    src/cpp/Window.cpp \
    src/cpp/View.cpp

HEADERS += src/cpp/blusher_plugin.h \
    include/blusher.h \
    include/blusher/Application.h \
    src/Application_bridge.h \
    include/blusher/blusher-qt.h \
    src/cpp/DesktopEnvironment.h \
    src/cpp/Window.h \
    src/cpp/View.h

TARGET = blusher

