QT = gui quick quickwidgets

CONFIG += c++11
!macx: CONFIG(debug, debug|release){
    CONFIG += console
}

DEFINES += QT_DEPRECATED_WARNINGS

INCLUDEPATH += ../include

LIBS +=

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

QML_IMPORT_PATH += ../lib/blusher/qml

#QML2_IMPORT_PATH += ../lib/blusher/qml

DEFINES += BLUSHER_APP_VERSION=\\\"0.1.0\\\" \
        BLUSHER_APP_NAME=\\\"Scratcher\\\" \
        BLUSHER_PATH=\\\"../lib/blusher\\\" \
        BLUSHER_DEBUG

contains(DEFINES, BLUSHER_DEBUG) {
    message("BLUSHER IS DEBUG MODE!")
}

win32: LIBS += -L$$PWD/../lib/blusher/qml/Blusher/ -lblusher
win32: DEPENDPATH += $$PWD/../include
win32: PRE_TARGETDEPS += $$PWD/../lib/blusher/qml/Blusher/blusher.lib
