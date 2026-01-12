public struct Radius {
    public var topLeft: Float
    public var topRight: Float
    public var bottomRight: Float
    public var bottomLeft: Float

    public init(all: Float) {
        topLeft = all
        topRight = all
        bottomRight = all
        bottomLeft = all
    }

    public init(topLeft: Float, topRight: Float, bottomRight: Float, bottomLeft: Float) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
}
