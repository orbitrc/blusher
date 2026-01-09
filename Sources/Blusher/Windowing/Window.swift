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


public class UIWindow: UISurface {
    private var _decorationView: UIView!
    private var _shadow: WindowShadow!
    private var _resize: WindowResize!
    private var _titleBar: TitleBar!
    private var _bodyView: UIView!
    private var _body: Widget!
}

public struct Window<Content: View>: Surface {
    private var content: Content

    @State var surfaceSize: SizeI = SizeI(width: 300, height: 200)
    @State var resizeGeometry: Rect = Rect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    @State var titleBarGeometry: Rect = Rect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()

        updateResizeGeometry()
        updateTitleBarGeometry()
    }

    public var body: some Surface {
        ToplevelSurface {
            WindowShadow()
                .geometry(
                    Rect(x: 0.0, y: 0.0, width: Float(surfaceSize.width), height: Float(surfaceSize.height))
                )
            WindowResize()
                .geometry(resizeGeometry)
            TitleBar()
                .geometry(titleBarGeometry)
            Rectangle()
                .geometry(Rect(x: 150.0, y: 150.0, width: 30.0, height: 30.0))
                .color(Color(r: 100, g: 0, b: 0, a: 255))
                .onPointerPress { _ in
                    SurfaceHandle.current?.startResize(.bottomRight)
                }
            content
        }
        .size(surfaceSize)
        .onResizeRequest { event in
            surfaceSize = SizeI(
                width: UInt64(event.size.width),
                height: UInt64(event.size.height)
            )

            updateResizeGeometry()
            updateTitleBarGeometry()
        }
    }

    private func updateResizeGeometry() {
        resizeGeometry = Rect(
            x: WindowShadow.thickness - WindowResize.thickness,
            y: WindowShadow.thickness - WindowResize.thickness,
            width: Float(surfaceSize.width) - WindowShadow.thickness * 2,
            height: Float(surfaceSize.height) - WindowShadow.thickness * 2
        )
    }

    private func updateTitleBarGeometry() {
        titleBarGeometry = Rect(
            x: WindowShadow.thickness + 1.0,
            y: WindowShadow.thickness + 1.0,
            width: resizeGeometry.width,
            height: TitleBar.thickness
        )
    }
}

    /*

    public var body: Widget {
        get {
            return _body
        }
    }

    public var surfaceSize: SizeI {
        get {
            return SizeI(width: super.size.width, height: super.size.height)
        }
        set {
            super.size = SizeI(width: newValue.width, height: newValue.height)
        }
    }

    public var windowGeometry: RectI {
        get {
            return super.wmGeometry
        }
        set {
            super.wmGeometry = newValue
        }
    }

    public init() {
        super.init(role: .toplevel)

        // Decorations.
        let decoViewRect = Rect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        _decorationView = View(parentPointer: rootViewPointer,
            surface: self,
            geometry: decoViewRect)
        _decorationView.color = Color(r: 0, g: 0, b: 0, a: 0)

        // - Shadow.
        _shadow = WindowShadow(decoration: _decorationView)

        // - Resize
        _resize = WindowResize(decoration: _decorationView)

        // - Title bar.
        _titleBar = TitleBar(decoration: _decorationView)

        rootViewColor = Color(r: 0, g: 0, b: 0, a: 0)

        // Body.
        let bodyViewRect = Rect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        _bodyView = View(parentPointer: rootViewPointer,
            surface: self,
            geometry: bodyViewRect)
        _body = Widget(parentView: _bodyView)

        updateSurfaceSize()
        updateBodyGeometry()
        updateShadowGeometry()
        updateResizeGeometry()
        updateTitleBarGeometry()
    }

    public func startMove() {
        super.move()
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

    private func updateSurfaceSize() {
        let surfaceSize = SizeI(
            width: UInt64(body.size.width + (_shadow.thickness * 2)),
            height: UInt64(body.size.height + (_shadow.thickness * 2))
        )
        self.surfaceSize = surfaceSize

        // Fit decoration view size to surface.
        _decorationView.size = Size(
            width: Float(surfaceSize.width),
            height: Float(surfaceSize.height)
        )
    }

    private func updateBodyGeometry() {
        let newGeo = Rect(
            x: _shadow.thickness,
            y: _shadow.thickness + _titleBar.thickness,
            width: Float(surfaceSize.width) - (_shadow.thickness * 2),
            height: Float(surfaceSize.height) - (_shadow.thickness * 2) - _titleBar.thickness
        )

        _bodyView.geometry = newGeo
        _body.geometry = Rect(x: 0.0, y: 0.0, width: newGeo.width, height: newGeo.height)
    }

    private func updateWindowGeometry() {
        let newGeo = RectI(
            x: Int64(_shadow.thickness),
            y: Int64(_shadow.thickness),
            width: 100,
            height: 100
        )
        // TODO.
    }

    private func updateShadowGeometry() {
        _shadow.geometry = Rect(
            x: 0.0,
            y: 0.0,
            width: Float(surfaceSize.width),
            height: Float(surfaceSize.height)
        )
    }

    private func updateResizeGeometry() {
        let x = _shadow.thickness - (_resize.thickness)
        let y = _shadow.thickness - (_resize.thickness)
        let width = _shadow.size.width - (_shadow.thickness * 2) + (_resize.thickness * 2);
        let height = _shadow.size.height - (_shadow.thickness * 2) + (_resize.thickness * 2);

        _resize.geometry = Rect(
            x: x,
            y: y,
            width: width,
            height: height
        )
    }

    private func updateTitleBarGeometry() {
        _titleBar.geometry = Rect(
            x: _shadow.thickness,
            y: _shadow.thickness,
            width: _shadow.size.width,
            height: _titleBar.thickness
        )
    }

    override public func resizingEvent(_ event: ResizeEvent) {
        print("Resizing - now \(event.size.width)x\(event.size.height)")

        surfaceSize = SizeI(
            width: UInt64(event.size.width),
            height: UInt64(event.size.height)
        )

        updateShadowGeometry()
    }
}
*/
