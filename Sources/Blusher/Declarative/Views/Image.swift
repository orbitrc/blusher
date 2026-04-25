public struct Image: View {
    private var _path: String

    internal var path: String? {
        if _path == "" {
            return nil
        }
        return _path
    }

    public var body: some View {
        EmptyView()
    }

    public init(path: String) {
        _path = path
    }

    /// View geometry.
    public func geometry(_ geometry: Rect) -> some View {
        modifier { store in
            store[GeometryKey.self] = geometry
        }
    }

    /// Image size.
    public func size(_ size: SizeI) -> some View {
        modifier { store in
            store[SizeIKey.self] = size
        }
    }

    public func color(_ color: Color) -> some View {
        modifier { store in
            store[ColorKey.self] = color
        }
    }
}
