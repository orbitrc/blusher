public class Bytes {
    private var _ptr: UnsafeMutableBufferPointer<UInt8>? = nil
    private var _len: UInt64 = 0

    public var count: Int {
        Int(_len)
    }

    public var baseAddress: UnsafeMutableRawPointer? {
        UnsafeMutableRawPointer(_ptr?.baseAddress)
    }

    public init(_ data: UnsafeMutableBufferPointer<UInt8>?, _ length: UInt64) {
        _ptr = data
        _len = length
    }

    deinit {
        if _ptr != nil {
            _ptr?.deallocate()
        }
    }
}
