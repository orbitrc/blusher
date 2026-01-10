@_implementationOnly import Swingby

public enum SurfaceRole {
    case toplevel
    case popup
}

public enum ResizeEdge {
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

public class UISurface {
    private var _sbDesktopSurface: OpaquePointer? = nil
    private var _parent: UISurface? = nil

    private var _resizeRequestEventListener: EventListener!

    internal var _resizeRequestHandler: ((ResizeEvent) -> Void)? = nil

    // TODO: Change this to internal when the test done.
    public var rootViewPointer: OpaquePointer {
        get {
            let sbSurface = sb_desktop_surface_surface(_sbDesktopSurface)
            let sbRootView = sb_surface_root_view(sbSurface)

            return sbRootView!
        }
    }

    internal var cPointer: OpaquePointer? {
        self._sbDesktopSurface
    }

    public var children: [UIView] = []

    public var rootViewColor: Color {
        get {
            // TODO: Impl.
            return Color(r: 255, g: 255, b: 255, a: 255)
        }
        set(newValue) {
            var sbColor = sb_color_t(
                r: newValue.r,
                g: newValue.g,
                b: newValue.b,
                a: newValue.a
            )

            withUnsafePointer(to: &sbColor) { ptr in
                sb_view_set_color(rootViewPointer, ptr)
            }
        }
    }

    public var size: SizeI {
        get {
            let sbSurface = sb_desktop_surface_surface(_sbDesktopSurface)
            let sbSize = UnsafeMutablePointer(mutating: sb_surface_size(sbSurface))

            let width: Float = sb_size_width(sbSize)
            let height: Float = sb_size_height(sbSize)

            return SizeI(width: UInt64(width), height: UInt64(height))
        }
        set {
            let sbSurface = sb_desktop_surface_surface(_sbDesktopSurface)

            var sbSize = sb_size_t(
                width: Float(newValue.width),
                height: Float(newValue.height)
            )

            withUnsafePointer(to: &sbSize) { ptr in
                sb_surface_set_size(sbSurface, ptr)
            }
        }
    }

    public var wmGeometry: RectI {
        get {
            // TODO: Impl.
            return RectI(x: 0, y: 0, width: 0, height: 0)
        }
        set {
            var sbRect = sb_rect_t(
                pos: sb_point_t(x: Float(newValue.pos.x), y: Float(newValue.pos.y)),
                size: sb_size_t(width: Float(newValue.size.width), height: Float(newValue.size.height))
            )

            withUnsafePointer(to: &sbRect) { ptr in
                sb_desktop_surface_set_wm_geometry(_sbDesktopSurface, ptr)
            }
        }
    }

    public var inputGeometry: RectI {
        get {
            // TODO: Impl.
            return RectI(x: 0, y: 0, width: 0, height: 0)
        }
        set {
            var sbRect = sb_rect_t(
                pos: sb_point_t(x: Float(newValue.pos.x), y: Float(newValue.pos.y)),
                size: sb_size_t(width: Float(newValue.size.width), height: Float(newValue.size.height))
            )

            withUnsafeMutablePointer(to: &sbRect) { ptr in
                let sbSurface = sb_desktop_surface_surface(_sbDesktopSurface)
                sb_surface_set_input_geometry(sbSurface, ptr)
            }
        }
    }

    public let role: SurfaceRole

    public init(role: SurfaceRole, _ parent: UISurface? = nil) {
        self.role = role
        _parent = parent

        let sbRole = role == .toplevel
            ? SB_DESKTOP_SURFACE_ROLE_TOPLEVEL
            : SB_DESKTOP_SURFACE_ROLE_POPUP
        _sbDesktopSurface = sb_desktop_surface_new(sbRole)

        if _parent != nil {
            // sb_desktop_surface_set_parent()
        }

        rootViewColor = Color(r: 0, g: 0, b: 0, a: 0)

        addEventListeners()
    }

    public func close() {
        if role == .toplevel {
            sb_desktop_surface_toplevel_close(_sbDesktopSurface)
        }
    }

    public func move() {
        sb_desktop_surface_toplevel_move(_sbDesktopSurface)
    }

    public func resize(_ resizeEdge: ResizeEdge) {
        if role != .toplevel {
            return
        }

        let sbEdge = switch resizeEdge {
            case .top: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_TOP
            case .bottom: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_BOTTOM
            case .left: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_LEFT
            case .right: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_RIGHT
            case .topLeft: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_TOP_LEFT
            case .topRight: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_TOP_RIGHT
            case .bottomLeft: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_BOTTOM_LEFT
            case .bottomRight: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_BOTTOM_RIGHT
        }

        sb_desktop_surface_toplevel_resize(_sbDesktopSurface, sbEdge)
    }

    public func show() {
        sb_desktop_surface_show(_sbDesktopSurface)
    }

    private func addEventListeners() {
        let userData = Unmanaged.passUnretained(self).toOpaque()

        // Resizing event.
        _resizeRequestEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UISurface>.fromOpaque(userData).takeUnretainedValue()

                instance.callResizingEvent(sbEvent)
            }
        } as EventListener
        sb_desktop_surface_add_event_listener(_sbDesktopSurface, SB_EVENT_TYPE_RESIZE,
            _resizeRequestEventListener, userData)
    }

    private func callResizingEvent(_ sbEvent: UnsafeMutablePointer<sb_event_t>?) {
        let sbOldSize = sb_event_resize_old_size(sbEvent)
        let sbSize = sb_event_resize_size(sbEvent)

        let oldSize = Size(
            width: sb_size_width(UnsafeMutablePointer(mutating: sbOldSize)),
            height: sb_size_height(UnsafeMutablePointer(mutating: sbOldSize))
        )
        let size = Size(
            width: sb_size_width(UnsafeMutablePointer(mutating: sbSize)),
            height: sb_size_height(UnsafeMutablePointer(mutating: sbSize))
        )

        let event = ResizeEvent(oldSize: oldSize, size: size)
        resizeRequestEvent(event)
    }

    open func resizeRequestEvent(_ event: ResizeEvent) {
        ToplevelStorage._uiSurface = self
        _resizeRequestHandler?(event)
        ToplevelStorage._uiSurface = nil
    }
}

public protocol Surface: Visible {
    associatedtype Body : Visible

    @SurfaceBuilder
    var body: Body { get }
}

public struct EmptySurface: Surface {
    public var body: some Surface {
        self
    }

    public init() {
    }
}

@resultBuilder
public struct SurfaceBuilder {
    public static func buildBlock<Content: Visible>(_ content: Content) -> Content {
        content
    }

    public static func buildBlock<C0: Visible, C1: Visible>(_ c0: C0, _ c1: C1) -> TupleVisible<(C0, C1)> {
        TupleVisible((c0, c1))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleVisible<(C0, C1, C2)> {
        TupleVisible((c0, c1, c2))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleVisible<(C0, C1, C2, C3)> {
        TupleVisible((c0, c1, c2, c3))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible, C4: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleVisible<(C0, C1, C2, C3, C4)> {
        TupleVisible((c0, c1, c2, c3, c4))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible, C4: Visible, C5: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleVisible<(C0, C1, C2, C3, C4, C5)> {
        TupleVisible((c0, c1, c2, c3, c4, c5))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible, C4: Visible, C5: Visible, C6: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleVisible<(C0, C1, C2, C3, C4, C5, C6)> {
        TupleVisible((c0, c1, c2, c3, c4, c5, c6))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible, C4: Visible, C5: Visible, C6: Visible, C7: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleVisible<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        TupleVisible((c0, c1, c2, c3, c4, c5, c6, c7))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible, C4: Visible, C5: Visible, C6: Visible, C7: Visible, C8: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleVisible<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        TupleVisible((c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }

    public static func buildBlock<C0: Visible, C1: Visible, C2: Visible, C3: Visible, C4: Visible, C5: Visible, C6: Visible, C7: Visible, C8: Visible, C9: Visible>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleVisible<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        TupleVisible((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }
}

public struct ToplevelSurface<Content: Visible>: Surface {
    public var content: Content

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    public var body: Content {
        content
    }
}

public struct SurfaceProxy {
    private weak var uiSurface: UISurface?

    init(_ uiSurface: UISurface) {
        self.uiSurface = uiSurface
    }

    public func close() {
        self.uiSurface?.close()
    }

    public func startMove() {
        self.uiSurface?.move()
    }

    public func startResize(_ edge: ResizeEdge) {
        self.uiSurface?.resize(edge)
    }
}

enum ToplevelStorage {
    nonisolated(unsafe) static var _uiSurface: UISurface? = nil
}

public class SurfaceHandle {
    public static var current: SurfaceProxy? {
        guard let uiSurface = ToplevelStorage._uiSurface else { return nil }
        return SurfaceProxy(uiSurface)
    }

    private init() {}
}
