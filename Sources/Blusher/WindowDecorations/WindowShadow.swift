public class WindowShadow: Widget, WindowDecoration {
    public var thickness: Float = 40.0

    public init(decoration: View) {
        super.init(parentView: decoration)

        self.color = Color(r: 128, g: 128, b: 128, a: 128)
    }
}
