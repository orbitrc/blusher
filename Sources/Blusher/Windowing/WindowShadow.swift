public struct WindowShadow: View, WindowDecoration {
    public static var thickness: Float {
        get { 40.0 }
        set { return }
    }

    public var body: some View {
        Rectangle()
            .color(.black)
    }
}
