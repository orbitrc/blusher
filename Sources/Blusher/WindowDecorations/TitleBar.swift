public class TitleBar: Widget, WindowDecoration {
    public var thickness: Float = 30.0

    private var _pressed: Bool = false

    public init(decoration: View) {
        super.init(parentView: decoration)

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
