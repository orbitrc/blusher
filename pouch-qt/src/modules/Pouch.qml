pragma Singleton
import QtQuick 2.12

Item {
  id: root

  enum FileType {
    Directory,
    File,
    SymbolicLink
  }

  property string pwd: '/'
  property var fs: QtObject {
    property var files: {
      '/': {
        'type': Pouch.FileType.Directory,
        'data': [ '/home' ]
      },
      '/home': {
        'type': Pouch.FileType.Directory,
        'data': [ '/home/user' ]
      },
      '/home/user': {
        'type': Pouch.FileType.Directory,
        'data': [ '/home/user/Documents' ]
      },
      '/home/user/Documents': {
        'type': Pouch.FileType.Directory,
        'data': [ '/home/user/Documents/README' ]
      },
      '/home/user/Documents/README': {
        'type': Pouch.FileType.File,
        'data': 'hello'
      }
    }
  }

  function cd(path) {
    root.pwd = path;
  }

  function ls(path) {
    let files = [];
  }

  Component.onCompleted: {
  }
}
