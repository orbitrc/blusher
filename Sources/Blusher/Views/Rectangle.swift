public struct Rectangle: View {
    private var _geometry: Rect
    private var _color: Color
    // private var surface: any Surface

    public var body: some View {
        self
    }

    public var geometry: Rect {
        _geometry
    }

    public var color: Color {
        _color
    }

    public init() {
        _geometry = Rect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        _color = Color(r: 255, g: 255, b: 255, a: 255)
    }

    public func color(_ color: Color) -> Self {
        var copy = self
        copy._color = color

        return copy
    }
}
