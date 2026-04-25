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
    public func geometry(_ geometry: Rect) -> some View {
        self.modifier { store in
            store[GeometryKey.self] = geometry
        }
    }
}

struct SizeIKey: PropertyKey {
    typealias Value = SizeI

    static var defaultValue: SizeI {
        SizeI(width: 100, height: 100)
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

//=============
// Shape
//=============

struct RadiusKey: PropertyKey {
    typealias Value = Radius

    static var defaultValue: Value {
        Radius(all: 0.0)
    }
}

struct CursorShapeKey: PropertyKey {
    typealias Value = CursorShape

    static var defaultValue: Value {
        .default
    }
}

//=============
// Filters
//=============

struct FiltersKey: PropertyKey {
    typealias Value = [Filter]

    static var defaultValue: Value {
        []
    }
}

//=============
// Event
//=============

struct PointerEnterKey: PropertyKey {
    typealias Value = ((PointerEvent) -> Void)?

    static var defaultValue: Value {
        nil
    }
}

struct PointerLeaveKey: PropertyKey {
    typealias Value = ((PointerEvent) -> Void)?

    static var defaultValue: Value {
        nil
    }
}

struct PointerMoveKey: PropertyKey {
    typealias Value = ((PointerEvent) -> Void)?

    static var defaultValue: Value {
        nil
    }
}

struct PointerPressKey: PropertyKey {
    typealias Value = ((PointerEvent) -> Void)?

    static var defaultValue: Value {
        nil
    }
}

struct PointerReleaseKey: PropertyKey {
    typealias Value = ((PointerEvent) -> Void)?

    static var defaultValue: Value { nil }
}

struct PointerClickKey: PropertyKey {
    typealias Value = ((PointerEvent) -> Void)?

    static var defaultValue: Value { nil }
}

struct ResizeRequestKey: PropertyKey {
    typealias Value = ((ResizeEvent) -> Void)?

    static var defaultValue: Value { nil }
}

extension View {
    public func onPointerEnter(_ handler: ((PointerEvent) -> Void)?) -> some View {
        self.modifier { store in
            store[PointerEnterKey.self] = handler
        }
    }

    public func onPointerLeave(_ handler: ((PointerEvent) -> Void)?) -> some View {
        self.modifier { store in
            store[PointerLeaveKey.self] = handler
        }
    }

    public func onPointerMove(_ handler: ((PointerEvent) -> Void)?) -> some View {
        self.modifier { store in
            store[PointerMoveKey.self] = handler
        }
    }

    public func onPointerPress(_ handler: ((PointerEvent) -> Void)?) -> some View {
        self.modifier { store in
            store[PointerPressKey.self] = handler
        }
    }

    public func onPointerRelease(_ handler: ((PointerEvent) -> Void)?) -> some View {
        self.modifier { store in
            store[PointerReleaseKey.self] = handler
        }
    }

    public func onPointerClick(_ handler: ((PointerEvent) -> Void)?) -> some View {
        self.modifier { store in
            store[PointerClickKey.self] = handler
        }
    }
}

//==================
// Surface
//==================

struct WMGeometryKey: PropertyKey {
    typealias Value = RectI?

    static var defaultValue: Value { nil }
}

struct InputGeometryKey: PropertyKey {
    typealias Value = RectI?

    static var defaultValue: Value { nil }
}
