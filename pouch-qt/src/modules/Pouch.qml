pragma Singleton
import QtQuick 2.12

Item {
  property string pwd: '/'
  property var fs: {
    '/': [
      {
        'home': [
          {
            'user': [
              {
                'Documents': [
                  {
                    'README': {}
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }

  function test() {
    print('test');
  }

  Component.onCompleted: {
  }
}
