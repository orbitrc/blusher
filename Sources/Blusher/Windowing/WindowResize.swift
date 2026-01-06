public struct WindowResize: View, WindowDecoration {
    public static var thickness: Float {
        get { 5.0 }
        set { return }
    }

    public var body: some View {
        Rectangle()
            .color(Color(r: 80, g: 80, b: 255, a: 255))
    }

    public func geometry(_ geometry: Rect) -> some View {
        modifier { store in
            store[GeometryKey.self] = geometry
        }
    }
}

/*
public class WindowResize: Widget, WindowDecoration {
    class Edge: Widget {
        private var _edge: WindowResizeEdge!
        private var _window: UIWindow!
        private var _pressed: Bool = false

        init(edge: WindowResizeEdge, parent: Widget, window: UIWindow) {
            super.init(parent: parent)

            _edge = edge
            _window = window
        }

        override func pointerPressEvent(_ event: PointerEvent) {
            _pressed = true

            super.pointerPressEvent(event)
        }

        override func pointerMoveEvent(_ event: PointerEvent) {
            if _pressed {
                // _window.startResize(from: _edge)
                _pressed = false
            }

            super.pointerMoveEvent(event)
        }
    }

    public var thickness: Float = 15.0

    private var _bottomRightEdge: Edge!

    public init(decoration: UIView) {
        super.init(parentView: decoration)

        // Edges.
        _bottomRightEdge = Edge(edge: .bottomRight, parent: self, window: self.window)

        self.color = Color(r: 128, g: 0, b: 0, a: 100)

        updateEdges()
    }

    private func updateEdges() {
        _bottomRightEdge.size = Size(width: thickness, height: thickness)
    }
}
*/
