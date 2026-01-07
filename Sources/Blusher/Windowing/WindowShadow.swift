public struct WindowShadow: View, WindowDecoration {
    public static var thickness: Float {
        get { 40.0 }
        set { return }
    }

    public var body: some View {
        Rectangle()
            .color(Color(r: 128, g: 128, b: 128, a: 128))
    }
}
