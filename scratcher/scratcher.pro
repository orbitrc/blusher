QT = gui quick widgets

CONFIG += c++11
CONFIG(debug, debug|release){
    CONFIG += console
}

DEFINES += QT_DEPRECATED_WARNINGS

INCLUDEPATH += ../include

LIBS += -L../lib/blusher/qml/Blusher -lblusher

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

QML_IMPORT_PATH += ../lib/blusher/qml

QML2_IMPORT_PATH += ../lib/blusher/qml

DEFINES += BLUSHER_APP_VERSION=\\\"0.1.0\\\" \
        BLUSHER_APP_NAME=\\\"Scratcher\\\"
