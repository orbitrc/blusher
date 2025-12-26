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
        let body = instance.body

        if body is EmptySurface {
            // Body is empty.
            // Do nothing.
        } else if body is _TupleVisible{
            // Body is multiple surfaces.

            // uiSurface.show()
            // SurfaceManager.shared.register(uiSurface)
        } else {
            // Body is single surface.
            let surface = body

            let uiSurface = UISurface(role: .toplevel)

            let renderer = ViewRenderer(uiSurface: uiSurface)

            if surface.body is any View {
                print("Single View!")
                var builder = ViewRenderer.Builder()
                builder.parent = nil
                builder.rootViewPointer = uiSurface.rootViewPointer

                renderer.render(
                    view: surface.body as! any View,
                    store: PropertyStore(),
                    parentUIView: nil,
                    rootViewPointer: uiSurface.rootViewPointer
                )
            } else if surface.body is _TupleView {
                print("Multiple Views!")
            }

            uiSurface.show()
            SurfaceManager.shared.register(uiSurface)
        }

        let ret = _app.exec()
    }
}
