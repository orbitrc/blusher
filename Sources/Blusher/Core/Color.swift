public struct Color: Equatable {
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float

    public init(r: Float, g: Float, b: Float, a: Float) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    public init(r256: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.r = Float(r256) / 255.0
        self.g = Float(g) / 255.0
        self.b = Float(b) / 255.0
        self.a = Float(a) / 255.0
    }
}

public extension Color {
    static var black: Color {
        Color(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
    }

    static var white: Color {
        Color(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
    }

    static var red: Color {
        Color(r: 1.0, g: 0.0, b: 0.0, a: 1.0)
    }

    static var transparent: Color {
        Color(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
    }
}
