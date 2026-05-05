public class Bytes {
    private var _ptr: UnsafeMutableBufferPointer<UInt8>? = nil
    private var _len: UInt64 = 0
    private var _static: Bool = false

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

    /// Initialize with static data. Do not use this with dymamically allocated data.
    public init(fromStatic data: UnsafePointer<UInt8>, size: Int) {
        _static = true
        _ptr = UnsafeMutableBufferPointer<UInt8>(
            start: UnsafeMutablePointer(mutating: data),
            count: size
        )
        _len = UInt64(size)
    }

    deinit {
        if _static == true {
            return
        }
        if _ptr != nil {
            _ptr?.deallocate()
        }
    }
}
