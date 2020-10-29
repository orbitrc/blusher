Blusher
==========

Desktop GUI Toolkit written in QML.


Install
----------

Blusher is dependent in Qt and QML(with QtQuick). so before install Blusher, install Qt dependencies.

### ubuntu 19.04

```sh
$ sudo apt-get update
$ sudo apt-get install libqt5gui5 libqt5qml5 libqt5quick5 qml-module-qtquick2 qml-module-qtquick-layouts qml-module-qtquick-window2 qml-module-qtgraphicaleffects
```
### Common

Currently Blusher default supports only path exactly /usr/lib/blusher

```sh
$ sudo make install
```

Above command will copy lib/blusher directory in the project root to /usr/lib/


Setup Development Environment
------------------------------

WARNING! THIS GUIDE IS NOT COMPLETE!!

### ubuntu 19.04

Download and install Qt Creator from Qt official homepage.

```sh
$ sudo apt-get install qt5-qmake qt5-default qtdeclarative5-dev qml qml-module-qtquick2 qml-module-qtquick-window2
```


Pouch
----------

Pouch is the demo app using Blusher. It is a simple virtual file manager.

!This is currently not developed.

Scratcher
----------

Scratcher is the Blusher demo. You can test blusher views with this app.


Development
------------

### Predefined macros

Predefined macros provide meta information or change behavior when compiling an app.

#### BLUSHER\_APP\_NAME

type: string

This is your app's name. Commonly in English.

If not defined, empty string is assigned.


#### BLUSHER\_APP\_VERSION

type: string

This is your app's version. App version should follow SemVer.

If not defined, empty string is assigned.


#### BLUSHER\_DEBUG

type: bool

If this macro defined, Blusher QML is running in debug mode.

Do not use this for production.

#### BLUSHER\_PATH

type: string

The path of Blusher library.

