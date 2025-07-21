@_implementationOnly import Swingby

open class View {
    private var _sbView: OpaquePointer?
    private var _surface: Surface!

    private var _pointerEnterEventListener: EventListener!
    private var _pointerLeaveEventListener: EventListener!
    private var _pointerMoveEventListener: EventListener!
    private var _pointerPressEventListener: EventListener!

    public var color: Color {
        get {
            // TODO: Impl.
            return Color(r: 0, g: 0, b: 0, a: 255)
        }
        set(newValue) {
            var sbColor = sb_color_t(
                r: newValue.r,
                g: newValue.g,
                b: newValue.b,
                a: newValue.a
            )

            withUnsafePointer(to: &sbColor) { ptr in
                sb_view_set_color(_sbView, ptr)
            }
        }
    }

    public var geometry: Rect {
        get {
            let sbRect = sb_view_geometry(_sbView)
            let x = sbRect!.pointee.pos.x
            let y = sbRect!.pointee.pos.y
            let width = sbRect!.pointee.size.width
            let height = sbRect!.pointee.size.height

            return Rect(x: x, y: y, width: width, height: height)
        }
        set {
            var sbRect = sb_rect_t(
                pos: sb_point_t(x: newValue.pos.x, y: newValue.pos.y),
                size: sb_size_t(width: newValue.size.width, height: newValue.size.height)
            )

            withUnsafePointer(to: &sbRect) { ptr in
                sb_view_set_geometry(_sbView, ptr)
            }
        }
    }

    public var size: Size {
        get {
            return Size(width: geometry.size.width, height: geometry.size.height)
        }
        set(newValue) {
            let geo = Rect(
                x: geometry.pos.x, y: geometry.pos.y,
                width: newValue.width, height: newValue.height
            )
            geometry = geo
        }
    }

    public var surface: Surface {
        get {
            return _surface
        }
    }

    public init(parent: View, geometry: Rect) {
        let sbParent = parent._sbView
        var sbRect = sb_rect_t(
            pos: sb_point_t(x: geometry.x, y: geometry.y),
            size: sb_size_t(width: geometry.width, height: geometry.height)
        )

        withUnsafePointer(to: &sbRect) { ptr in
            _sbView = sb_view_new(sbParent, ptr)
        }

        _surface = parent._surface

        addEventListeners()
    }

    internal init(parentPointer: OpaquePointer, surface: Surface, geometry: Rect) {
        var sbRect = sb_rect_t(
            pos: sb_point_t(x: geometry.x, y: geometry.y),
            size: sb_size_t(width: geometry.width, height: geometry.height)
        )

        withUnsafePointer(to: &sbRect) { ptr in
            _sbView = sb_view_new(parentPointer, ptr)
        }

        _surface = surface

        addEventListeners()
    }

    private func addEventListeners() {
        let userData = Unmanaged.passUnretained(self).toOpaque()

        // Pointer enter event.
        _pointerEnterEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<View>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerEnterEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_ENTER,
            _pointerEnterEventListener, userData)

        // Pointer leave event.
        _pointerLeaveEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<View>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerLeaveEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_LEAVE,
            _pointerLeaveEventListener, userData)

        // Pointer move event.

        // Pointer press event.
        _pointerPressEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<View>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerPressEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_PRESS,
            _pointerPressEventListener, userData)
    }

    private func callPointerEnterEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
        let sbPos = sb_event_pointer_position(sbEvent)
        let x = sb_point_x(sbPos)
        let y = sb_point_y(sbPos)
        let event = PointerEvent(type: .pointerEnter)
        event.position.x = x
        event.position.y = y
        pointerEnterEvent(event)
    }

    private func callPointerLeaveEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
        let sbPos = sb_event_pointer_position(sbEvent)
        let x = sb_point_x(sbPos)
        let y = sb_point_y(sbPos)
        let event = PointerEvent(type: .pointerEnter)
        event.position.x = x
        event.position.y = y
        pointerLeaveEvent(event)
    }

    private func callPointerMoveEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
        //
    }

    private func callPointerPressEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
        let sbButton = sb_event_pointer_button(sbEvent)
        let button: PointerButton = switch sbButton {
            case SB_POINTER_BUTTON_NONE: .none
            case SB_POINTER_BUTTON_LEFT: .left
            case SB_POINTER_BUTTON_RIGHT: .right
            case SB_POINTER_BUTTON_MIDDLE: .middle
            default: .none
        }

        let sbPos = sb_event_pointer_position(sbEvent)
        let x = sb_point_x(sbPos)
        let y = sb_point_y(sbPos)

        let event = PointerEvent(type: .pointerPress)
        event.button = button
        event.position.x = x
        event.position.y = y
        pointerPressEvent(event)
    }

    open func pointerEnterEvent(_ event: PointerEvent) {
        //
    }

    open func pointerLeaveEvent(_ event: PointerEvent) {
        //
    }

    open func pointerMoveEvent(_ event: PointerEvent) {
        //
    }

    open func pointerPressEvent(_ event: PointerEvent) {
        //
    }
}
