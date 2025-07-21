public struct Rect {
    public var pos: Point = Point(x: 0.0, y: 0.0)
    public var size: Size = Size(width: 0.0, height: 0.0)

    public init(x: Float, y: Float, width: Float, height: Float) {
        pos.x = x
        pos.y = y
        size.width = width
        size.height = height
    }

    public var x: Float {
        get {
            return pos.x
        }
    }

    public var y: Float {
        get {
            return pos.y
        }
    }

    public var width: Float {
        get {
            return size.width
        }
    }

    public var height: Float {
        get {
            return size.height
        }
    }
}

public struct RectI {
    public var pos: PointI = PointI(x: 0, y: 0)
    public var size: SizeI = SizeI(width: 0, height: 0)

    public init(x: Int64, y: Int64, width: UInt64, height: UInt64) {
        pos.x = x
        pos.y = y
        size.width = width
        size.height = height
    }
}
