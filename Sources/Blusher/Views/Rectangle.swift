public struct Rectangle: View {
    // private var surface: any Surface
    private func defaultAction(_ store: inout PropertyStore) {
        store[GeometryKey.self] = Rect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        store[ColorKey.self] = Color(r: 255, g: 255, b: 255, a: 255)
    }

    public var body: some View {
        EmptyView()
        // modifier(self.defaultAction)
    }

    public init() {
    }

    public func geometry(_ geometry: Rect) -> some View {
        modifier { store in
            store[GeometryKey.self] = geometry
        }
    }

    public func color(_ color: Color) -> some View {
        modifier { store in
            store[ColorKey.self] = color
        }
    }
}
