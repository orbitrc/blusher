@_implementationOnly import Swingby

public class ImageHandle {
    internal var _sbImage: OpaquePointer?

    public var width: Int {
        let sbSizeI = sb_image_size(_sbImage)
        let width = sb_size_i_width(
            UnsafeMutablePointer.init(mutating: sbSizeI)
        )

        return Int(width)
    }

    public var height: Int {
        let sbSizeI = sb_image_size(_sbImage)
        let height = sb_size_i_height(
            UnsafeMutablePointer.init(mutating: sbSizeI)
        )

        return Int(height)
    }

    public init(from data: Bytes) {
        _sbImage = sb_image_new_from_data(data.baseAddress!, UInt64(data.count))
    }

    public init(fromURL url: String) {
        if !url.starts(with: "brc://") {
            print("Not a valid URL or not implemented yet: \(url)")
            _sbImage = nil
            return
        } else {
            let name = String(url.trimmingPrefix("brc://"))
            guard let rc = ResourceManager.shared.getResource(name) else { return }
            _sbImage = sb_image_new_from_data(rc.data.baseAddress!, UInt64(rc.data.count))
        }
    }

    deinit {
        if _sbImage == nil { return }
        sb_image_free(_sbImage)
    }
}
