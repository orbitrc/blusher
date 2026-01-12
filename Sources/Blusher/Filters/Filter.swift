public enum FilterType {
    case blur
    case dropShadow
}

public protocol Filter {
    var type: FilterType { get }
}

public struct Blur: Filter {
    public var type: FilterType { .blur }

    public var radius: Float = 0.0

    public init(radius: Float) {
        self.radius = radius
    }
}

public struct DropShadow: Filter {
    public var type: FilterType { .dropShadow }

    public var offset: Point = Point(x: 0.0, y: 0.0)
    public var radius: Float = 0.0
    public var color: Color = Color(r: 0, g: 0, b: 0, a: 0)

    public init(offset: Point, radius: Float, color: Color) {
        self.offset = offset
        self.radius = radius
        self.color = color
    }
}
