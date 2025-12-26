public protocol PropertyKey {
    associatedtype Value

    static var defaultValue: Value { get }
}

//=================
// Geometry
//=================

struct GeometryKey: PropertyKey {
    typealias Value = Rect

    static var defaultValue: Value {
        Rect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    }
}

extension View {
    func geometry(_ geometry: Rect) -> some View {
        self.modifier { store in
            store[GeometryKey.self] = geometry
        }
    }
}

//============
// Color
//============

struct ColorKey: PropertyKey {
    typealias Value = Color

    static var defaultValue: Value {
        Color(r: 0, g: 0, b: 0, a: 0)
    }
}

extension View {
    public func color(_ color: Color) -> some View {
        self.modifier { store in
            store[ColorKey.self] = color
        }
    }
}
