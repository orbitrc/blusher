public enum TitleBarButtonAction {
    case close
    case minimize
    case maximizeRestore
}

public class TitleBarButton: Widget {
    var action: TitleBarButtonAction = .close

    public init(action: TitleBarButtonAction, parent: Widget) {
        super.init(parent: parent)

        self.action = action

        size = Size(width: 24.0, height: 24.0)

        switch action {
        case .close:
            color = Color(r: 255, g: 0, b: 0, a: 255)
        case .minimize:
            color = Color(r: 255, g: 255, b: 0, a: 255)
        case .maximizeRestore:
            color = Color(r: 0, g: 255, b: 0, a: 255)
        }
    }

    public override func pointerClickEvent(_ event: PointerEvent) {
        switch action {
        case .close:
            window.close()
        case .minimize:
            // window.minimize()
            break
        case .maximizeRestore:
            // window.maximizeRestore()
            break
        }
    }
}

public class TitleBar: Widget, WindowDecoration {
    public var thickness: Float = 30.0

    private var _pressed: Bool = false

    private var _closeButton: TitleBarButton!
    private var _minimizeButton: TitleBarButton!
    private var _maximizeRestoreButton: TitleBarButton!

    public init(decoration: View) {
        super.init(parentView: decoration)

        // Title bar buttons.
        _closeButton = TitleBarButton(action: .close, parent: self)
        _minimizeButton = TitleBarButton(action: .minimize, parent: self)
        _maximizeRestoreButton = TitleBarButton(action: .maximizeRestore, parent: self)

        _closeButton.position = Point(x: 3.0, y: 3.0)
        _minimizeButton.position = Point(x: 30.0, y: 3.0)
        _maximizeRestoreButton.position = Point(x: 60.0, y: 3.0)

        color = Color(r: 128, g: 128, b: 128, a: 255)
    }

    public override func pointerPressEvent(_ event: PointerEvent) {
        _pressed = true
        print("TitleBar - pointerPressEvent")

        super.pointerPressEvent(event)
    }

    public override func pointerMoveEvent(_ event: PointerEvent) {
        if _pressed {
            window.startMove()
            _pressed = false
        }

        // event.propagation = false

        super.pointerMoveEvent(event)
    }
}
