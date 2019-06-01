pragma Singleton
import QtQuick 2.12

Item {
  id: root
  property string msg: "Hi!"

  function setMsg(text) {
    root.msg = text
  }
}
