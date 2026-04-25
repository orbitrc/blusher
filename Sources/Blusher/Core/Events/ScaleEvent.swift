public class ScaleEvent: Event {
    public var scale: Int

    public init(scale: Int) {
        self.scale = scale

        super.init(of: .preferredScale)
    }
}
