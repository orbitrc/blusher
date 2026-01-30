@_implementationOnly import Swingby

public class ApplicationHandle {
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

    private var _surfaces: [SurfaceHandle] = []
    private var _viewRenderer: ViewRenderer!

    internal var rootSurface: any Surface = EmptySurface()

    private init() {
    }

    func createSurface(root surface: any Surface) {
        rootSurface = surface

        initialize(surface: rootSurface, store: PropertyStore())
    }

    private func visit(
        surface: any Surface,
        store: PropertyStore,
        action: (any Surface, PropertyStore) -> SurfaceHandle
    ) {
        var store = store

        // Bind `@State`s.`
        let mirror = Mirror(reflecting: surface)
        for child in mirror.children {
            if let state = child.value as? _State {
                state.setOnChange {
                    print(" Value \(child.label) changed!")
                    self.updateHandler()
                }
            }
        }

        if let modifier = surface as? _PropertyModifiedSurface {
            modifier.apply(&store)

            visit(surface: modifier.innerContent, store: store, action: action)

            return
        }

        if surface.body is any Surface {
            print("Surface body is another surface.")
            visit(surface: surface.body as! any Surface, store: store, action: action)

            return
        } else if surface.body is any View {
            print("Surface body is now a view!")
            let _ = action(surface, store)
        }

        // if surface.body is any View {
        //     let _ = action(surface, store)
        // }
        // let _ = action(surface, store)
    }

    private func initialize(surface: any Surface, store: PropertyStore) {
        visit(surface: surface, store: store) { surface, store in
            // TODO: Do Not hard-code the role as toplevel.
            let uiSurface = SurfaceHandle(role: .toplevel)

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

            _viewRenderer = ViewRenderer(uiSurface: uiSurface, view: surface.body as! any View)
            let _ = SurfaceManager.renderViews(surface.body as! any View, _viewRenderer)

            _surfaces.append(uiSurface)
            uiSurface.show()

            return uiSurface
        }
        _viewRenderer.stateBounded = true
    }

    private func update(surface: any Surface, store: PropertyStore) {
        print(" - SurfaceManager.update()")
        visit(surface: rootSurface, store: store) { surface, store in
            let uiSurface = _surfaces[0]

            uiSurface.size = store[SizeIKey.self]

            if let rootView = surface.body as? any View {
                _viewRenderer.rootView = rootView
                _viewRenderer.updateHandler()
            }

            return uiSurface
        }
    }

    private func updateHandler() {
        update(surface: rootSurface, store: PropertyStore())
    }

    static func renderViews(_ body: any View, _ renderer: ViewRenderer) -> SurfaceHandle {
        if body is _TupleView {
            print("Multiple Views!")

            if let tupleViews = body as? _TupleView {
                for iter in tupleViews.getViews() {
                    renderer.render(
                        view: iter,
                        store: PropertyStore(),
                        parentViewHandle: nil
                    )
                }
            }
        } else if body is any View {
            print("Single View!")
            renderer.render(
                view: body as! any View,
                store: PropertyStore(),
                parentViewHandle: nil
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

        let app: ApplicationHandle = ApplicationHandle(args)

        let instance = Self()
        let body = instance.body
        let surface = body

        print("if surface is... \(surface)")
        if surface is EmptySurface {
            // Body is empty.
            // Do nothing.
        } else if body is _TupleVisible{
            // Body is multiple surfaces.

            // uiSurface.show()
            // SurfaceManager.shared.register(uiSurface)
        } else if surface.body is any Surface {
            print("Body is another surface")
            SurfaceManager.shared.createSurface(root: surface)
        } else {
            print("Body maybe a view")
            // Body is single surface.
            SurfaceManager.shared.createSurface(root: surface)
        }

        let ret = app.exec()

        return ret
    }
}
