open class Widget: View {
    public init(parent: Widget) {
        let initialRect = Rect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        super.init(parent: parent, geometry: initialRect)
    }

    internal init(parentView: View) {
        let initialRect = Rect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        super.init(parent: parentView, geometry: initialRect)
    }

    public var window: Window {
        get {
            return super.surface as! Window
        }
    }
}
