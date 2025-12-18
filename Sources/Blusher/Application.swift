@_implementationOnly import Swingby

public class UIApplication {
    private var _sbApplication: OpaquePointer? = nil

    public init(_ args: [String]) {
        let argc = Int32(args.count)
        let cArgs: [UnsafeMutablePointer<CChar>?] = args.map {
            $0.withCString { UnsafeMutablePointer(mutating: $0) }
        }

        cArgs.withUnsafeBufferPointer { buffer in
            let argv = UnsafeMutablePointer(mutating: buffer.baseAddress)
            let result = sb_application_new(argc, argv)
            _sbApplication = result
        }
    }

    public func exec() -> Int {
        return Int(sb_application_exec(_sbApplication))
    }
}

@MainActor
class SurfaceManager {
    static let shared: SurfaceManager = SurfaceManager()

    private var _surfaces: [UISurface] = []

    private init() {
    }

    func register(_ surface: UISurface) {
        _surfaces.append(surface)
    }
}

public protocol Application {
    associatedtype Body: Surface

    @SurfaceBuilder
    var body: Body { get }

    init()
}

extension Application {
    @MainActor
    public static func applicationMain() {
        let args = CommandLine.arguments

        var _app: UIApplication = UIApplication(args)

        let instance = Self()
        let _ = instance.body

        if instance.body is EmptySurface {
            // Do nothing.
        } else {
            let surface = UISurface(role: .toplevel)

            let renderer = ViewRenderer()
            renderer.render(view: instance.body.body as! any View, surface: surface, parent: surface.rootViewPointer)

            surface.show()
            SurfaceManager.shared.register(surface)
        }

        let ret = _app.exec()
    }
}
