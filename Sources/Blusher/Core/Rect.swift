public struct Rect: Equatable {
    public var position: Point = Point(x: 0.0, y: 0.0)
    public var size: Size = Size(width: 0.0, height: 0.0)

    public init(x: Float, y: Float, width: Float, height: Float) {
        position.x = x
        position.y = y
        size.width = width
        size.height = height
    }

    public var x: Float {
        get {
            return position.x
        }
    }

    public var y: Float {
        get {
            return position.y
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

extension Rect: CustomStringConvertible {
    public var description: String {
        return "Blusher.Rect(\(x), \(y) \(width)x\(height))"
    }
}

public struct RectI: Equatable {
    public var position: PointI = PointI(x: 0, y: 0)
    public var size: SizeI = SizeI(width: 0, height: 0)

    public init(x: Int64, y: Int64, width: UInt64, height: UInt64) {
        position.x = x
        position.y = y
        size.width = width
        size.height = height
    }
}
