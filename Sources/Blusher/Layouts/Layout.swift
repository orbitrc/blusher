public protocol Layout: Visible {
    associatedtype Body : View

    @ViewBuilder
    var body: Body { get }

    var selfContent: any View { get }

    var childrenContent: any View { get }

    func constraintFunction(_: ViewHandle) -> Void
}

public struct LayoutConstraint {
    var rootNode: ViewHandle
    var childNodes: [ViewHandle]
    var constraintFunction: ((ViewHandle) -> Void)
}
