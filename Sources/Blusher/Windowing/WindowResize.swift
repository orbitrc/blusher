struct WindowResizeEdge: View {
    private let _edge: ResizeEdge

    init(at edge: ResizeEdge) {
        _edge = edge
    }

    var body: some View {
        Rectangle()
            .color(Color(r: 255, g: 0, b: 0, a: 150))
            .onPointerPress { _ in
                SurfaceHandle.current?.startResize(_edge)
            }
    }
}

public struct WindowResize: View, WindowDecoration {
    public static var thickness: Float {
        get { 8.0 }
        set { return }
    }

    public var body: some View {
        Rectangle()
            .color(Color(r: 80, g: 80, b: 255, a: 255))
            .children {
                WindowResizeEdge(at: .topLeft)
                    .geometry(Rect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
            }
    }

    // public func geometry(_ geometry: Rect) -> some View {
    //     modifier { store in
    //         store[GeometryKey.self] = geometry
    //     }
    // }
}
