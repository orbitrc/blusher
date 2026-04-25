struct PropertyStore {
    private var storage: [ObjectIdentifier: Any] = [:]

    subscript<K: PropertyKey>(_ key: K.Type) -> K.Value {
        get {
            storage[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue
        }
        set {
            storage[ObjectIdentifier(key)] = newValue
        }
    }
}
