import Foundation

@_implementationOnly import Swingby

public class Application {
    private var _sbApplication: OpaquePointer? = nil

    public init(_ args: [String]) {
        let argc = Int32(args.count)
        let cArgs: [UnsafeMutablePointer<CChar>?] = args.map { strdup($0) } + [nil]

        cArgs.withUnsafeBufferPointer { buffer in
            let argv = UnsafeMutablePointer(mutating: buffer.baseAddress)
            let result = sb_application_new(argc, argv)
            _sbApplication = result
        }

        for ptr in cArgs where ptr != nil {
            free(ptr)
        }
    }

    public func exec() -> Int {
        return Int(sb_application_exec(_sbApplication))
    }
}
