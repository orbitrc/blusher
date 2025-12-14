@_implementationOnly import Swingby

public enum EventType {
    case pointerEnter
    case pointerLeave
    case pointerMove
    case pointerPress
    case pointerRelease
    case pointerClick
    case resize
}

typealias EventListener = @convention(c) (
    UnsafeMutablePointer<sb_event_t>?,
    UnsafeMutableRawPointer?
) -> Void

public class Event {
    public var type: EventType
    public var propagation: Bool {
        get {
            if swingbyEvent != nil {
                return sb_event_propagation(swingbyEvent)
            }

            return true
        }
        set {
            if swingbyEvent != nil {
                sb_event_set_propagation(swingbyEvent, newValue)
            }
        }
    }

    internal var swingbyEvent: UnsafeMutablePointer<sb_event_t>? = nil

    public init(of type: EventType) {
        self.type = type
    }
}
