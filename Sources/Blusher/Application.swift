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

    internal var rootSurface: any Surface = EmptySurface()

    private init() {
    }

    func createSurface(_ surface: any Surface) -> UISurface {
        rootSurface = surface

        let uiSurface = initialize(surface: surface, store: PropertyStore())
        return uiSurface
    }

    private func visit(
        surface: any Surface,
        store: PropertyStore,
        action: (any Surface, PropertyStore) -> UISurface
    ) {
        var store = store

        // Bind `@State`s.`
        let mirror = Mirror(reflecting: surface)
        for child in mirror.children {
            if let state = child.value as? _State {
                state.setOnChange(self.updateHandler)
            }
        }

        if let modifier = surface as? _PropertyModifiedSurface {
            modifier.apply(&store)

            visit(surface: modifier.innerContent, store: store, action: action)

            return
        }

        let _ = action(surface, store)
    }

    private func initialize(surface: any Surface, store: PropertyStore) -> UISurface {
        visit(surface: surface, store: store) { surface, store in
            // TODO: Do Not hard-code the role as toplevel.
            let uiSurface = UISurface(role: .toplevel)

            // let viewRenderer = ViewRenderer(uiSurface: uiSurface, view: surface.body as! any View)
            uiSurface.size = store[SizeIKey.self]
            if let wmGeometry = store[WMGeometryKey.self] {
                uiSurface.wmGeometry = wmGeometry
            }
            if let inputGeometry = store[InputGeometryKey.self] {
                uiSurface.inputGeometry = inputGeometry
            }
            if let handler = store[ResizeRequestKey.self] {
                uiSurface._resizeRequestHandler = handler
            }

            if let body = surface.body as? any View {
                let renderer = ViewRenderer(uiSurface: uiSurface, view: surface.body as! any View)
                let _ = SurfaceManager.renderViews(surface.body as! any View, renderer)

                _surfaces.append(uiSurface)
                uiSurface.show()
            }

            return uiSurface
        }

        return _surfaces[0]
    }

    private func update(surface: any Surface, store: PropertyStore) -> UISurface {
        print("TODO: Implement SurfaceManager.update")
        return _surfaces[0]
    }

    private func updateHandler() {
        print("updateHandler")
        let _ = update(surface: rootSurface, store: PropertyStore())
    }

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
        } else if body is any Surface {
            print("body.body is any Surface")
            let surface = body as? any Surface

            if let s = surface {
                let uiSurface = SurfaceManager.shared.createSurface(s)

                // let _ = renderViews(s.body as! any View, renderer)
            }

            /*
            let uiSurface = UISurface(role: .toplevel)

            let renderer = ViewRenderer(uiSurface: uiSurface, view: surface?.body as! any View)

            let _ = renderViews(surface?.body as! any View, renderer)
            uiSurface.show()

            SurfaceManager.shared.register(uiSurface)
            */
        } else if body is _TupleVisible{
            // Body is multiple surfaces.

            // uiSurface.show()
            // SurfaceManager.shared.register(uiSurface)
        } else {
            // Body is single surface.
            let surface = body

            let uiSurface = UISurface(role: .toplevel)

            let renderer = ViewRenderer(uiSurface: uiSurface, view: surface.body as! any View)

            // let _ = renderViews(surface.body as! any View, renderer)

            uiSurface.show()
            // SurfaceManager.shared.register(uiSurface)
        }

        let ret = app.exec()

        return ret
    }
}
