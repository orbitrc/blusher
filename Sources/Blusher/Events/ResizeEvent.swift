public class ResizeEvent: Event {
    public var oldSize: Size
    public var size: Size

    public init(oldSize: Size, size: Size) {
        self.oldSize = oldSize
        self.size = size

        super.init(of: .resize)
    }
}
