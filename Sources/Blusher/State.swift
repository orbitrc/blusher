internal class StateBox<T> {
    var value: T {
        didSet {
            print("StateBox<T>::value::didSet. onChange: \(onChange == nil)")
            onChange?()
        }
    }

    var onChange: (() -> Void)?

    init(_ value: T) {
        self.value = value
    }
}

internal protocol _State {
    func setOnChange(_ onChange: @escaping () -> Void) -> Void
}

@propertyWrapper
public struct State<T> : _State {
    private let box: StateBox<T>

    internal func setOnChange(_ onChange: @escaping () -> Void) {
        box.onChange = onChange
    }

    public init(wrappedValue: T) {
        self.box = StateBox(wrappedValue)
    }

    public var wrappedValue: T {
        get { self.box.value }
        nonmutating set { self.box.value = newValue}
    }

    public var projectedValue: Binding<T> {
        Binding(
            get: { box.value },
            set: { box.value = $0 }
        )
    }
}
