@_implementationOnly import Swingby

open class UIView {
    private var _sbView: OpaquePointer?
    private var _surface: UISurface!
    private var _parent: UIView?

    private var _pointerEnterEventListener: EventListener!
    private var _pointerLeaveEventListener: EventListener!
    private var _pointerMoveEventListener: EventListener!
    private var _pointerPressEventListener: EventListener!
    private var _pointerReleaseEventListener: EventListener!
    private var _pointerClickEventListener: EventListener!

    internal var _pointerEnterHandler: ((PointerEvent) -> Void)? = nil
    internal var _pointerLeaveHandler: ((PointerEvent) -> Void)? = nil
    internal var _pointerMoveHandler: ((PointerEvent) -> Void)? = nil
    internal var _pointerPressHandler: ((PointerEvent) -> Void)? = nil
    internal var _pointerReleaseHandler: ((PointerEvent) -> Void)? = nil
    internal var _pointerClickHandler: ((PointerEvent) -> Void)? = nil

    internal var cPointer: OpaquePointer? {
        _sbView
    }

    public var parent: UIView? {
        _parent
    }

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

    public var position: Point {
        get {
            return Point(x: geometry.pos.x, y: geometry.pos.y)
        }
        set {
            let geo = Rect(
                x: newValue.x, y: newValue.y,
                width: geometry.size.width, height: geometry.size.height
            )
            geometry = geo
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

    public var surface: UISurface {
        get {
            return _surface
        }
    }

    public init(parent: UIView, geometry: Rect) {
        let sbParent = parent._sbView
        var sbRect = sb_rect_t(
            pos: sb_point_t(x: geometry.x, y: geometry.y),
            size: sb_size_t(width: geometry.width, height: geometry.height)
        )

        withUnsafePointer(to: &sbRect) { ptr in
            _sbView = sb_view_new(sbParent, ptr)
        }

        _surface = parent._surface
        _surface.children.append(self)
        _parent = parent

        addEventListeners()
    }

    internal init(parentPointer: OpaquePointer, surface: UISurface, geometry: Rect) {
        var sbRect = sb_rect_t(
            pos: sb_point_t(x: geometry.x, y: geometry.y),
            size: sb_size_t(width: geometry.width, height: geometry.height)
        )

        withUnsafePointer(to: &sbRect) { ptr in
            _sbView = sb_view_new(parentPointer, ptr)
        }

        _surface = surface
        _surface.children.append(self)
        _parent = nil

        addEventListeners()
    }

    private func addEventListeners() {
        let userData = Unmanaged.passUnretained(self).toOpaque()

        // Pointer enter event.
        _pointerEnterEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UIView>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerEnterEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_ENTER,
            _pointerEnterEventListener, userData)

        // Pointer leave event.
        _pointerLeaveEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UIView>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerLeaveEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_LEAVE,
            _pointerLeaveEventListener, userData)

        // Pointer move event.
        _pointerMoveEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UIView>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerMoveEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_MOVE,
            _pointerMoveEventListener, userData)

        // Pointer press event.
        _pointerPressEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UIView>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerPressEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_PRESS,
            _pointerPressEventListener, userData)

        // Pointer release event.
        _pointerReleaseEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UIView>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerReleaseEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_RELEASE,
            _pointerReleaseEventListener, userData)

        // Pointer click event.
        _pointerClickEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UIView>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerClickEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_CLICK,
            _pointerClickEventListener, userData)
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
        let sbPos = sb_event_pointer_position(sbEvent)
        let x = sb_point_x(sbPos)
        let y = sb_point_y(sbPos)
        let event = PointerEvent(type: .pointerMove)
        event.position.x = x
        event.position.y = y
        pointerMoveEvent(event)
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
        event.swingbyEvent = sbEvent
        pointerPressEvent(event)
    }

    private func callPointerReleaseEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
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

        let event = PointerEvent(type: .pointerRelease)
        event.button = button
        event.position.x = x
        event.position.y = y
        event.swingbyEvent = sbEvent
        pointerReleaseEvent(event)
    }

    private func callPointerClickEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
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

        let event = PointerEvent(type: .pointerClick)
        event.button = button
        event.position.x = x
        event.position.y = y
        event.swingbyEvent = sbEvent
        pointerClickEvent(event)
    }

    open func pointerEnterEvent(_ event: PointerEvent) {
        ToplevelStorage._uiSurface = self._surface
        _pointerEnterHandler?(event)
        ToplevelStorage._uiSurface = nil
    }

    open func pointerLeaveEvent(_ event: PointerEvent) {
        //
    }

    open func pointerMoveEvent(_ event: PointerEvent) {
        ToplevelStorage._uiSurface = self._surface
        _pointerMoveHandler?(event)
        ToplevelStorage._uiSurface = nil
    }

    open func pointerPressEvent(_ event: PointerEvent) {
        ToplevelStorage._uiSurface = self._surface
        _pointerPressHandler?(event)
        ToplevelStorage._uiSurface = nil
    }

    open func pointerReleaseEvent(_ event: PointerEvent) {
    }

    open func pointerClickEvent(_ event: PointerEvent) {
    }
}

internal protocol _TupleView {
    func getViews() -> [any View]
}

public struct TupleView<T>: View {
    public var value: T

    public var body: some View {
        EmptyView()
    }

    public init(_ value: T) {
        self.value = value
    }
}

extension TupleView: _TupleView {
    func getViews() -> [any View] {
        let mirror = Mirror(reflecting: self.value)
        return mirror.children.compactMap { $0.value as? any View }
    }
}

extension Never: View {
    public typealias Body = Never

    public var body: Never {
        fatalError("Never body.")
    }
}

public struct EmptyView: View {
    public typealias Body = Never

    public var body: Never {
        fatalError("EmptyView has no body")
    }

    public init() {
    }
}

@resultBuilder
public struct ViewBuilder {
    public static func buildBlock() -> EmptyView {
        EmptyView()
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : View {
        content
    }

    public static func buildBlock<C0: View, C1: View>(_ c0: C0, _ c1: C1) -> TupleView<(C0, C1)> {
        TupleView((c0, c1))
    }

    public static func buildBlock<C0: View, C1: View, C2: View>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView<(C0, C1, C2)> {
        TupleView((c0, c1, c2))
    }
}

public protocol View: Visible {
    associatedtype Body : View

    @ViewBuilder
    var body: Body { get }
}

struct ChildrenModifiedView<Content: View, Children: View>: View {
    let content: Content
    let children: Children

    var body: some View {
        content
    }
}

extension View {
    public func children(@ViewBuilder _ content: () -> some View) -> some View {
        ChildrenModifiedView(content: self, children: content())
    }
}

class ViewRenderer {
    var uiSurface: UISurface
    var rootView: any View

    init(uiSurface: UISurface, view: any View) {
        self.uiSurface = uiSurface
        self.rootView = view
    }

    func visit(
        view: any View,
        store: PropertyStore,
        parentUIView: UIView?,
        action: (any View, PropertyStore, UIView?) -> UIView
    ) {
        var store = store

        print(" - Visiting: \(type(of: view))")
        //
        let mirror = Mirror(reflecting: view)
        for child in mirror.children {
            if let state = child.value as? _State {
                print("State found!")
                state.setOnChange {
                    self.updateHandler()
                }
            }
        }

        // Stop if empty view.
        // if view is EmptyView {
        //     print("Empty view. Stop.")
        //     return
        // }

        // Process modified view.
        if let modifier = view as? _PropertyModifiedView {
            modifier.apply(&store)

            visit(
                view: modifier.innerContent,
                store: store,
                parentUIView: parentUIView,
                action: action
            )

            return
        }

        // Process tuple view.
        if let tupleView = view as? _TupleView {
            for iter in tupleView.getViews() {
                visit(
                    view: (iter is _PropertyModifiedView) ? iter : iter,
                    store: store,
                    parentUIView: parentUIView,
                    action: action
                )
            }

            return
        } else if view.body is EmptyView {
            let _ = action(view, store, parentUIView)

            // visit(view: view.body, store: store, parentUIView: uiView, action: action)
        } else {
            visit(view: view.body, store: store, parentUIView: parentUIView, action: action)
        }
    }

    func render(view: any View, store: PropertyStore, parentUIView: UIView?) {
        visit(view: view, store: store, parentUIView: parentUIView) { view, store, parent in
            let uiView = parent == nil
            ? UIView(
                parentPointer: self.uiSurface.rootViewPointer,
                surface: self.uiSurface,
                geometry: store[GeometryKey.self]
            )
            : UIView(parent: parent!, geometry: store[GeometryKey.self])

            uiView.geometry = store[GeometryKey.self]
            uiView.color = store[ColorKey.self]
            bindHandler(for: PointerEnterKey.self, in: store, to: &uiView._pointerEnterHandler)
            bindHandler(for: PointerLeaveKey.self, in: store, to: &uiView._pointerLeaveHandler)
            bindHandler(for: PointerMoveKey.self, in: store, to: &uiView._pointerMoveHandler)
            bindHandler(for: PointerPressKey.self, in: store, to: &uiView._pointerPressHandler)
            bindHandler(for: PointerReleaseKey.self, in: store, to: &uiView._pointerReleaseHandler)
            bindHandler(for: PointerClickKey.self, in: store, to: &uiView._pointerClickHandler)

            return uiView
        }
    }

    func update(view: any View, store: PropertyStore, parentUIView: UIView?) {
        var index = 0
        visit(view: view, store: store, parentUIView: parentUIView) { view, store, parent in
            let uiView = uiSurface.children[index]

            uiView.geometry = store[GeometryKey.self]
            uiView.color = store[ColorKey.self]

            index += 1

            return uiView
        }
    }

    func updateHandler() {
        update(view: self.rootView, store: PropertyStore(), parentUIView: nil)
    }

    /// A helper function for bind event handlers.
    private func bindHandler<K: PropertyKey>(
        for key: K.Type,
        in store: PropertyStore,
        to target: inout K.Value
    ) {
        target = store[key]
    }
}
