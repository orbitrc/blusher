pragma Singleton
import QtQuick 2.12
import ".."       // Blusher.DesktopEnvironment

QtObject {
  function shortcutToString(shortcut) {
    let text = '';
    const modifiers = shortcut & 0xff000000;
    const key = shortcut & 0x00ffffff;

    if (modifiers === DesktopEnvironment.KeyModifier.Shift) {
      text += 'Shift';
    } else if (modifiers === DesktopEnvironment.KeyModifier.Control) {
      text += 'Ctrl';
    }

    switch (key) {
    case Qt.Key_A:
      text += '+A';
      break;
    case Qt.Key_B:
      text += '+B';
      break;
    case Qt.Key_C:
      text += '+C';
      break;
    case Qt.Key_D:
      text += '+D';
      break;
    case Qt.Key_E:
      text += '+E';
      break;
    case Qt.Key_F:
      text += '+F';
      break;
    case Qt.Key_G:
      text += '+G';
      break;
    case Qt.Key_H:
      text += '+H';
      break;
    case Qt.Key_I:
      text += '+I';
      break;
    case Qt.Key_J:
      text += '+J';
      break;
    case Qt.Key_K:
      text += '+K';
      break;
    case Qt.Key_L:
      text += '+L';
      break;
    case Qt.Key_M:
      text += '+M';
      break;
    case Qt.Key_N:
      text += '+N';
      break;
    case Qt.Key_O:
      text += '+O';
      break;
    case Qt.Key_P:
      text += '+P';
      break;
    case Qt.Key_Q:
      text += '+Q';
      break;
    case Qt.Key_R:
      text += '+R';
      break;
    case Qt.Key_S:
      text += '+S';
      break;
    case Qt.Key_T:
      text += '+T';
      break;
    case Qt.Key_U:
      text += '+U';
      break;
    case Qt.Key_V:
      text += '+V';
      break;
    case Qt.Key_W:
      text += '+W';
      break;
    case Qt.Key_X:
      text += '+X';
      break;
    case Qt.Key_Y:
      text += '+Y';
      break;
    case Qt.Key_Z:
      text += '+Z';
      break;
    default:
      break;
    }

    return text;
  }
}
