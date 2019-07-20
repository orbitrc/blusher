QT = gui quick
CONFIG += c++11

VERSION = 0.1.0

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

INCLUDEPATH += ../include

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model

# If not updated:
# https://forum.qt.io/topic/92025/unknown-component-m300-for-custom-qml-class/3
QML_IMPORT_PATH += \
        ../lib/blusher/qml \
        ./src/modules

QML2_IMPORT_PATH +=

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

DEFINES += BLUSHER_APP_VERSION=\\\"$$VERSION\\\" \
        BLUSHER_APP_NAME=\\\"Pouch\\\" \
        BLUSHER_PATH=\\\"$$PWD/../lib/blusher/qml\\\" \
        BLUSHER_DEBUG
        # BLUSHER_PATH=\\\"/usr/lib/blusher/qml\\\"

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    ../lib/blusher/qml/Blusher/Alert.qml \
    ../lib/blusher/qml/Blusher/Button.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/DesktopEnvironment.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/Standalone/DebugPanel.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/Standalone/MenuItemStyler.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/Standalone/Overlay.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/qmldir \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/Standalone/MenuBarMenuDelegate.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/Standalone/PopUpMenuDelegate.qml \
    ../lib/blusher/qml/Blusher/DesktopEnvironment/Standalone/MenuItemDelegate.qml \
    ../lib/blusher/qml/Blusher/Label.qml \
    ../lib/blusher/qml/Blusher/Menu.qml \
    ../lib/blusher/qml/Blusher/MenuItem.qml \
    ../lib/blusher/qml/Blusher/MenuItemView.qml \
    ../lib/blusher/qml/Blusher/MenuView.qml \
    ../lib/blusher/qml/Blusher/Segment.qml \
    ../lib/blusher/qml/Blusher/SegmentedControl.qml \
    ../lib/blusher/qml/Blusher/SplitView.qml \
    ../lib/blusher/qml/Blusher/TestItem.qml \
    ../lib/blusher/qml/Blusher/TextField.qml \
    ../lib/blusher/qml/Blusher/Toolbar.qml \
    ../lib/blusher/qml/Blusher/ToolbarItem.qml \
    ../lib/blusher/qml/Blusher/Window.qml \
    ../lib/blusher/qml/Blusher/qmldir
