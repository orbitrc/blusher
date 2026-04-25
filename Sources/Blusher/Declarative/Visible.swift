public protocol Visible {
}

internal protocol _TupleVisible {
    func getChildren() -> [any Visible]
}

public struct TupleVisible<T>: Visible {
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
}

extension TupleVisible: _TupleVisible {
    func getChildren() -> [any Visible] {
        let mirror = Mirror(reflecting: self.value)
        return mirror.children.compactMap { $0.value as? any Visible }
    }
}
