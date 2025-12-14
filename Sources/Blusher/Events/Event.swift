@_implementationOnly import Swingby

public enum EventType {
    case pointerEnter
    case pointerLeave
    case pointerMove
    case pointerPress
    case resize
}

typealias EventListener = @convention(c) (
    UnsafeMutablePointer<sb_event_t>?,
    UnsafeMutableRawPointer?
) -> Void

public class Event {
    public var type: EventType

    public init(of type: EventType) {
        self.type = type
    }
}
