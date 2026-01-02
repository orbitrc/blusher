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
    public static func applicationMain() -> Int {
        let args = CommandLine.arguments

        let app: UIApplication = UIApplication(args)

        let instance = Self()
        let body = instance.body

        print("if body is... \(body)")
        if body is EmptySurface {
            // Body is empty.
            // Do nothing.
        } else if body.body is any Surface {
            print("body.body is any Surface")
            let surface = body.body as? any Surface

            let uiSurface = UISurface(role: .toplevel)

            let renderer = ViewRenderer(uiSurface: uiSurface, view: surface?.body as! any View)

            let _ = renderViews(surface?.body as! any View, renderer)
            uiSurface.show()

            SurfaceManager.shared.register(uiSurface)
        } else if body is _TupleVisible{
            // Body is multiple surfaces.

            // uiSurface.show()
            // SurfaceManager.shared.register(uiSurface)
        } else {
            // Body is single surface.
            let surface = body

            let uiSurface = UISurface(role: .toplevel)

            let renderer = ViewRenderer(uiSurface: uiSurface, view: surface.body as! any View)

            if surface.body is _TupleView {
                print("Multiple Views!")

                if let tupleViews = surface.body as? _TupleView {
                    for iter in tupleViews.getViews() {
                        renderer.render(
                            view: iter,
                            store: PropertyStore(),
                            parentUIView: nil
                        )
                    }
                }
            } else if surface.body is any View {
                print("Single View!")
                renderer.render(
                    view: surface.body as! any View,
                    store: PropertyStore(),
                    parentUIView: nil
                )
            }

            uiSurface.show()
            SurfaceManager.shared.register(uiSurface)
        }

        let ret = app.exec()

        return ret
    }
}

internal extension Application {
    static func renderViews(_ body: any View, _ renderer: ViewRenderer) -> UISurface {
        if body is _TupleView {
            print("Multiple Views!")

            if let tupleViews = body as? _TupleView {
                for iter in tupleViews.getViews() {
                    renderer.render(
                        view: iter,
                        store: PropertyStore(),
                        parentUIView: nil
                    )
                }
            }
        } else if body is any View {
            print("Single View!")
            renderer.render(
                view: body as! any View,
                store: PropertyStore(),
                parentUIView: nil
            )
        }

        return renderer.uiSurface
    }
}
