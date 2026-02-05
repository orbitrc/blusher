@_implementationOnly import Swingby

public enum ViewRenderType {
    case singleColor
    case image
}

open class ViewHandle {
    private var _sbView: OpaquePointer?
    private var _surface: SurfaceHandle!
    private var _parent: ViewHandle?

    private var _renderType: ViewRenderType = .singleColor
    private var _clip: Bool = false
    private var _color: Color = Color(r: 0, g: 0, b: 0, a: 0)
    private var _image: ImageHandle? = nil
    private var _geometry: Rect = Rect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    private var _cursorShape: CursorShape = .default

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

    public var parent: ViewHandle? {
        _parent
    }

    public var clip: Bool {
        get { _clip }
        set {
            if _clip == newValue {
                return
            }
            _clip = newValue

            sb_view_set_clip(_sbView, newValue)
        }
    }

    public var renderType: ViewRenderType {
        get { _renderType }
        set {
            if _renderType == newValue {
                return
            }
            _renderType = newValue

            let sbType = switch _renderType {
                case .singleColor: SB_VIEW_FILL_TYPE_SINGLE_COLOR
                case .image: SB_VIEW_FILL_TYPE_IMAGE
            }
            sb_view_set_fill_type(_sbView, sbType)
        }
    }

    public var color: Color {
        get {
            return _color
        }
        set(newValue) {
            if _color == newValue {
                return
            }

            _color = newValue

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

    public var image: ImageHandle? {
        get { _image }
        set {
            if let image = newValue {
                _image = image

                sb_view_set_image(_sbView, image._sbImage)
            } else {
                _image = nil

                sb_view_set_image(_sbView, nil)
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
            if _geometry == newValue {
                return
            }

            _geometry = newValue

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

    public var radius: Radius {
        get {
            // TODO: Implement!
            return Radius(all: 0.0)
        }
        set {
            var sbRadius = sb_view_radius_t(
                top_left: newValue.topLeft,
                top_right: newValue.topRight,
                bottom_right: newValue.bottomRight,
                bottom_left: newValue.bottomLeft
            )

            withUnsafePointer(to: &sbRadius) { ptr in
                sb_view_set_radius(_sbView, ptr)
            }
        }
    }

    public var cursorShape: CursorShape {
        get {
            _cursorShape
        }
        set {
            if _cursorShape == newValue {
                return
            }

            _cursorShape = newValue

            let sbCursorShape = CursorShape.toSwingbyCursorShape(newValue)
            sb_view_set_cursor_shape(_sbView, sbCursorShape)
        }
    }

    public var surface: SurfaceHandle {
        get {
            return _surface
        }
    }

    public init(parent: ViewHandle, geometry: Rect) {
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

        clip = true

        addEventListeners()
    }

    public init(surface: SurfaceHandle, geometry: Rect) {
        var sbRect = sb_rect_t(
            pos: sb_point_t(x: geometry.x, y: geometry.y),
            size: sb_size_t(width: geometry.width, height: geometry.height)
        )

        withUnsafePointer(to: &sbRect) { ptr in
            _sbView = sb_view_new(surface.rootViewPointer, ptr)
        }

        _surface = surface
        _surface.children.append(self)
        _parent = nil

        clip = true

        addEventListeners()
    }

    internal init(parentPointer: OpaquePointer, surface: SurfaceHandle, geometry: Rect) {
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

        clip = true

        addEventListeners()
    }

    public func addFilter(_ filter: Filter) {
        let sbFilterType = switch filter.type {
            case .blur:
                SB_FILTER_TYPE_BLUR
            case .dropShadow:
                SB_FILTER_TYPE_DROP_SHADOW
        }

        let sbFilter = sb_filter_new(sbFilterType)

        if let blur = filter as? Blur {
            sb_filter_blur_set_radius(sbFilter, blur.radius)

            sb_view_add_filter(_sbView, sbFilter)
        } else if let dropShadow = filter as? DropShadow {
            var offset = sb_point_t(x: dropShadow.offset.x, y: dropShadow.offset.y)
            var color = sb_color_t(
                r: dropShadow.color.r,
                g: dropShadow.color.g,
                b: dropShadow.color.b,
                a: dropShadow.color.a
            )

            withUnsafePointer(to: &offset) { ptr in
                sb_filter_drop_shadow_set_offset(sbFilter, ptr)
            }
            sb_filter_drop_shadow_set_radius(sbFilter, dropShadow.radius)
            withUnsafePointer(to: &color) { ptr in
                sb_filter_drop_shadow_set_color(sbFilter, ptr)
            }

            sb_view_add_filter(_sbView, sbFilter)
        }
    }

    private func addEventListeners() {
        let userData = Unmanaged.passUnretained(self).toOpaque()

        // Pointer enter event.
        _pointerEnterEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<ViewHandle>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerEnterEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_ENTER,
            _pointerEnterEventListener, userData)

        // Pointer leave event.
        _pointerLeaveEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<ViewHandle>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerLeaveEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_LEAVE,
            _pointerLeaveEventListener, userData)

        // Pointer move event.
        _pointerMoveEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<ViewHandle>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerMoveEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_MOVE,
            _pointerMoveEventListener, userData)

        // Pointer press event.
        _pointerPressEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<ViewHandle>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerPressEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_PRESS,
            _pointerPressEventListener, userData)

        // Pointer release event.
        _pointerReleaseEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<ViewHandle>.fromOpaque(userData).takeUnretainedValue()

                instance.callPointerReleaseEvent(sbEvent)
            }
        } as EventListener
        sb_view_add_event_listener(_sbView, SB_EVENT_TYPE_POINTER_RELEASE,
            _pointerReleaseEventListener, userData)

        // Pointer click event.
        _pointerClickEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<ViewHandle>.fromOpaque(userData).takeUnretainedValue()

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
        let event = PointerEvent(type: .pointerLeave)
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
        ToplevelStorage._uiSurface = self._surface
        _pointerLeaveHandler?(event)
        ToplevelStorage._uiSurface = nil
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
        ToplevelStorage._uiSurface = self._surface
        _pointerClickHandler?(event)
        ToplevelStorage._uiSurface = nil
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

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleView<(C0, C1, C2, C3)> {
        TupleView((c0, c1, c2, c3))
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleView<(C0, C1, C2, C3, C4)> {
        TupleView((c0, c1, c2, c3, c4))
    }
}

public protocol View: Visible {
    associatedtype Body : View

    @ViewBuilder
    var body: Body { get }
}

//===============
// Modifiers
//===============

extension View {
    public func radius(_ radius: Radius) -> some View {
        self.modifier { store in
            store[RadiusKey.self] = radius
        }
    }
}

extension View {
    public func filters(_ filters: [Filter]) -> some View {
        self.modifier { store in
            store[FiltersKey.self] = filters
        }
    }
}

extension View {
    public func cursorShape(_ cursorShape: CursorShape) -> some View {
        self.modifier { store in
            store[CursorShapeKey.self] = cursorShape
        }
    }
}

//==============
// Renderer
//==============

class ViewRenderer {
    var uiSurface: SurfaceHandle
    var rootView: any View
    var stateBounded: Bool = false

    init(uiSurface: SurfaceHandle, view: any View) {
        self.uiSurface = uiSurface
        self.rootView = view
    }

    func visit(
        view: any View,
        store: PropertyStore,
        parentViewHandle: ViewHandle?,
        action: (any View, PropertyStore, ViewHandle?) -> ViewHandle
    ) -> ViewHandle? {
        var store = store

        // print(" - Visiting: \(type(of: view))")
        //
        if !stateBounded {
            let mirror = Mirror(reflecting: view)
            for child in mirror.children {
                if let state = child.value as? _State {
                    state.setOnChange {
                        self.updateHandler()
                    }
                }
            }
        }

        // Process children views.
        if let childrenModifier = view as? _ChildrenModifiedView {
            let viewHandle = visit(
                view: childrenModifier.innerContent,
                store: store,
                parentViewHandle: parentViewHandle,
                action: action
            )

            let _ = visit(
                view: childrenModifier.childrenContent,
                store: store,
                parentViewHandle: viewHandle,
                action: action
            )

            return viewHandle
        }

        // Process modified view.
        if let modifier = view as? _PropertyModifiedView {
            modifier.apply(&store)

            return visit(
                view: modifier.innerContent,
                store: store,
                parentViewHandle: parentViewHandle,
                action: action
            )
        }

        // Process tuple view.
        if let tupleView = view as? _TupleView {
            for iter in tupleView.getViews() {
                let _ = visit(
                    view: (iter is _PropertyModifiedView) ? iter : iter,
                    store: store,
                    parentViewHandle: parentViewHandle,
                    action: action
                )
            }
        } else if view.body is EmptyView {
            return action(view, store, parentViewHandle)
        } else {
            return visit(view: view.body, store: store, parentViewHandle: parentViewHandle, action: action)
        }

        return parentViewHandle
    }

    func render(view: any View, store: PropertyStore, parentViewHandle: ViewHandle?) {
        print(" - ViewRenderer.render()")
        let _ = visit(view: view, store: store, parentViewHandle: parentViewHandle) { view, store, parent in
            let viewHandle = parent == nil
            ? ViewHandle(
                parentPointer: self.uiSurface.rootViewPointer,
                surface: self.uiSurface,
                geometry: store[GeometryKey.self]
            )
            : ViewHandle(parent: parent!, geometry: store[GeometryKey.self])

            // Basic appearance.
            viewHandle.geometry = store[GeometryKey.self]
            viewHandle.color = store[ColorKey.self]
            viewHandle.radius = store[RadiusKey.self]
            viewHandle.cursorShape = store[CursorShapeKey.self]
            // Filters.
            for filter in store[FiltersKey.self] {
                viewHandle.addFilter(filter)
            }
            // Image.
            if let imageView = view as? Image {
                viewHandle.renderType = .image
                if viewHandle.image == nil {
                    let file = FileSystem.File.open(imageView.path!, "rb")
                    viewHandle.image = ImageHandle(from: file.readAll())
                    file.close()
                }
            }
            // Events.
            bindHandler(for: PointerEnterKey.self, in: store, to: &viewHandle._pointerEnterHandler)
            bindHandler(for: PointerLeaveKey.self, in: store, to: &viewHandle._pointerLeaveHandler)
            bindHandler(for: PointerMoveKey.self, in: store, to: &viewHandle._pointerMoveHandler)
            bindHandler(for: PointerPressKey.self, in: store, to: &viewHandle._pointerPressHandler)
            bindHandler(for: PointerReleaseKey.self, in: store, to: &viewHandle._pointerReleaseHandler)
            bindHandler(for: PointerClickKey.self, in: store, to: &viewHandle._pointerClickHandler)

            return viewHandle
        }
    }

    func update(view: any View, store: PropertyStore, parentViewHandle: ViewHandle?) {
        print(" - ViewRenderer.update()")
        var index = 0
        let _ = visit(view: view, store: store, parentViewHandle: parentViewHandle) { view, store, parent in
            let viewHandle = uiSurface.children[index]

            viewHandle.geometry = store[GeometryKey.self]
            viewHandle.color = store[ColorKey.self]

            index += 1

            return viewHandle
        }
    }

    func updateHandler() {
        update(view: self.rootView, store: PropertyStore(), parentViewHandle: nil)
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
