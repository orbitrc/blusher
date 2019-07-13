QT = gui quick
CONFIG += c++11 console

DEFINES += QT_DEPRECATED_WARNINGS

TEMPLATE = lib

VERSION = 0.1.0

SOURCES += src/cpp/Application_bridge.cpp

HEADERS += src/Application_bridge.h \
    include/blusher/blusher-qt.h

TARGET = blusher

