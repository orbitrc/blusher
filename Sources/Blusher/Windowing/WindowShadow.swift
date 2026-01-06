public struct WindowShadow: View, WindowDecoration {
    public static var thickness: Float {
        get { 40.0 }
        set { return }
    }

    @State public var geometry: Rect = Rect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

    public var body: some View {
        Rectangle()
            .geometry(geometry)
            .color(Color(r: 128, g: 128, b: 128, a: 128))
    }
}
