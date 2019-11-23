QT = gui quick

CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

INCLUDEPATH += ../include

LIBS += -L../lib/blusher/qml/Blusher -lblusher

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

QML2_IMPORT_PATH += ../lib/blusher/qml

DEFINES += BLUSHER_APP_VERSION=\\\"0.1.0\\\" \
        BLUSHER_APP_NAME=\\\"Scratcher\\\"
