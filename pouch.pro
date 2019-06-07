QT = gui quick
CONFIG += c++11 console

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model

# If not updated:
# https://forum.qt.io/topic/92025/unknown-component-m300-for-custom-qml-class/3
QML_IMPORT_PATH += \
        ./src/qml

QML2_IMPORT_PATH +=

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

DEFINES += TEST_VALUE=\\\"test\\\" \
        BLUSHER_PATH=\\\"$$PWD/src/qml\\\"
        # BLUSHER_PATH=\\\"/usr/lib/blusher/qml\\\"

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    src/qml/Blusher/Button.qml \
    src/qml/Blusher/DesktopEnvironment/DesktopEnvironment.qml \
    src/qml/Blusher/DesktopEnvironment/qmldir \
    src/qml/Blusher/Menu.qml \
    src/qml/Blusher/MenuItem.qml \
    src/qml/Blusher/MenuItemView.qml \
    src/qml/Blusher/MenuView.qml \
    src/qml/Blusher/MyWindow.qml \
    src/qml/Blusher/TestItem.qml \
    src/qml/Blusher/Toolbar.qml \
    src/qml/Blusher/ToolbarItem.qml \
    src/qml/Blusher/qmldir
