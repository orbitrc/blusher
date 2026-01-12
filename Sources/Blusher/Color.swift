public struct Color: Equatable {
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8
    public var a: UInt8

    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

public extension Color {
    static var black: Color {
        Color(r: 0, g: 0, b: 0, a: 255)
    }

    static var white: Color {
        Color(r: 255, g: 255, b: 255, a: 255)
    }

    static var red: Color {
        Color(r: 255, g: 0, b: 0, a: 255)
    }
}
