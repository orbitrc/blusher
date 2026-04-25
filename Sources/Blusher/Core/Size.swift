public struct Size: Equatable {
    public var width: Float
    public var height: Float

    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}

public struct SizeI: Equatable {
    public var width: UInt64
    public var height: UInt64

    public init(width: UInt64, height: UInt64) {
        self.width = width
        self.height = height
    }
}
