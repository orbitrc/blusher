public class Resource {
    public enum Compression {
        case none
        case zlib
        case zstd
    }

    private let _path: String
    private let _data: Bytes

    public var path: String {
        _path
    }

    public var data: Bytes {
        _data
    }

    public init(_ path: String, _ data: Bytes) {
        _path = path
        _data = data
    }
}
