@_implementationOnly import Swingby

func sb_test() {
    let args = CommandLine.arguments
    let argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>? = nil

    var app = sb_application_new(Int32(args.count), argv)
}
