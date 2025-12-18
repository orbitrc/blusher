@_implementationOnly import Swingby

public enum SurfaceRole {
    case toplevel
    case popup
}

public enum SurfaceResizeEdge {
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

    private var _resizingEventListener: EventListener!

    // TODO: Change this to internal when the test done.
    public var rootViewPointer: OpaquePointer {
        get {
            let sbSurface = sb_desktop_surface_surface(_sbDesktopSurface)
            let sbRootView = sb_surface_root_view(sbSurface)

            return sbRootView!
        }
    }

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

    public func resize(_ resizeEdge: SurfaceResizeEdge) {
        if role != .toplevel {
            return
        }

        let sbEdge = switch resizeEdge {
            case .top: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_TOP
            case .bottom: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_BOTTOM
            // TODO: Entire cases.
            default: SB_DESKTOP_SURFACE_TOPLEVEL_RESIZE_EDGE_BOTTOM_RIGHT
        }

        sb_desktop_surface_toplevel_resize(_sbDesktopSurface, sbEdge)
    }

    public func show() {
        sb_desktop_surface_show(_sbDesktopSurface)
    }

    private func addEventListeners() {
        let userData = Unmanaged.passUnretained(self).toOpaque()

        // Resizing event.
        _resizingEventListener = { sbEvent, userData in
            if let userData = userData {
                let instance = Unmanaged<UISurface>.fromOpaque(userData).takeUnretainedValue()

                instance.callResizingEvent(sbEvent)
            }
        } as EventListener
        sb_desktop_surface_add_event_listener(_sbDesktopSurface, SB_EVENT_TYPE_RESIZE,
            _resizingEventListener, userData)
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
        resizingEvent(event)
    }

    open func resizingEvent(_ event: ResizeEvent) {
        //
    }
}

public protocol Surface {
    associatedtype Body : Surface

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
    public static func buildBlock<Content>(_ content: Content) -> Content where Content : Surface {
        content
    }
}

public struct ToplevelSurface<Content>: Surface where Content : View {
    public var content: Content

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    public var body: some Surface {
        EmptySurface()
    }
}
