public class PointerEvent: Event {
    public var button: PointerButton
    public var position: Point

    public init(type: EventType) {
        button = .none
        position = Point(x: 0.0, y: 0.0)

        super.init(of: type)
    }
}
