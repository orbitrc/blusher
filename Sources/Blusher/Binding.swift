@propertyWrapper
public struct Binding<T> {
    public let get: () -> T
    public let set: (T) -> Void

    public var wrappedValue: T {
        get { get() }
        set { set(newValue) }
    }

    public init(get: @escaping () -> T, set: @escaping (T) -> Void) {
        self.get = get
        self.set = set
    }
}
