@_silgen_name("fopen")
func fopen(_: UnsafePointer<CChar>, _: UnsafePointer<CChar>) -> OpaquePointer

@_silgen_name("fseek")
func fseek(_: OpaquePointer, _: Int64, _: Int32) -> Int32

@_silgen_name("ftell")
func ftell(_: OpaquePointer) -> Int64

@_silgen_name("fread")
func fread(_: UnsafeMutableRawPointer, _: UInt, _: UInt, _: OpaquePointer) -> UInt

@_silgen_name("fclose")
func fclose(_: OpaquePointer) -> Int32

public enum FileSystem {
    public class File {
        private var _filePtr: OpaquePointer? = nil
        private var _path: String = ""
        private var _mode: String = ""

        private init() {
        }

        deinit {
            //
        }

        public static func open(_ path: String, _ mode: String) -> File {
            let file: File = File()
            file._path = path
            file._mode = mode

            path.withCString { cPath in
                mode.withCString { cMode in
                    file._filePtr = fopen(cPath, cMode)
                }
            }

            return file
        }

        public func readAll() -> Bytes {
            if let f = _filePtr {
                if fseek(f, 0, 2) != 0 {    // SEEK_END
                    return Bytes(nil, 0)
                }
                let len = ftell(f)
                let _ = fseek(f, 0, 0)      // SEEK_SET
                let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: Int(len))
                let _ = fread(buffer.baseAddress!, 1, UInt(len), f)

                return Bytes(buffer, UInt64(len))
            }

            return Bytes(nil, 0)
        }

        public func close() {
            if let ptr = _filePtr {
                let _ = fclose(ptr)
            }
        }
    }
}
