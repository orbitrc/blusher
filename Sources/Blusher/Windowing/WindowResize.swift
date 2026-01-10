public struct WindowResize: View, WindowDecoration {
    public static var thickness: Float {
        get { 5.0 }
        set { return }
    }

    public var body: some View {
        Rectangle()
            .color(Color(r: 80, g: 80, b: 255, a: 255))
    }

    // public func geometry(_ geometry: Rect) -> some View {
    //     modifier { store in
    //         store[GeometryKey.self] = geometry
    //     }
    // }
}
