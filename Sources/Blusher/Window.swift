@_implementationOnly import Swingby

public enum WindowResizeEdge {
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

public class Window: Surface {
    private var _bodyView: View!
    private var _body: Widget!

    public var body: Widget {
        get {
            return _body
        }
    }

    public var surfaceSize: SizeI {
        get {
            return SizeI(width: super.size.width, height: super.size.height)
        }
    }

    public init() {
        super.init(role: .toplevel)

        rootViewColor = Color(r: 0, g: 0, b: 0, a: 128)

        let bodyViewRect = Rect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        _bodyView = View(parentPointer: rootViewPointer,
            surface: self,
            geometry: bodyViewRect)
        _body = Widget(parentView: _bodyView)
    }

    public func startResize(from edge: WindowResizeEdge) {
        let surfaceEdge: SurfaceResizeEdge = switch edge {
            case .top: .top
            case .bottom: .bottom
            case .left: .left
            case .right: .right
            case .topLeft: .topLeft
            case .topRight: .topRight
            case .bottomLeft: .bottomLeft
            case .bottomRight: .bottomRight
        }

        super.resize(surfaceEdge)
    }
}
