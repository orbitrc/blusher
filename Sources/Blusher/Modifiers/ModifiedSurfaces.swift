protocol _PropertyModifiedSurface {
    var innerContent: any Surface { get }

    func apply(_: inout PropertyStore) -> Void
}

struct PropertyModifiedSurface<Content: Surface>: Surface, _PropertyModifiedSurface {
    let content: Content
    let action: (inout PropertyStore) -> Void

    var body: some Surface {
        content
    }

    var innerContent: any Surface {
        content
    }

    func apply(_ store: inout PropertyStore) {
        action(&store)
    }
}

extension Surface {
    func modifier(_ action: @escaping (inout PropertyStore) -> Void) -> some Surface {
        PropertyModifiedSurface(content: self, action: action)
    }
}

//===============
// Geometry
//===============

extension Surface {
    public func size(_ size: SizeI) -> some Surface {
        self.modifier { store in
            store[SizeIKey.self] = size
        }
    }
}

extension Surface {
    public func wmGeometry(_ geometry: RectI) -> some Surface {
        self.modifier { store in
            store[WMGeometryKey.self] = geometry
        }
    }
}

extension Surface {
    public func inputGeometry(_ geometry: RectI) -> some Surface {
        self.modifier { store in
            store[InputGeometryKey.self] = geometry
        }
    }
}

//=================
// Event Handlers
//=================

extension Surface {
    public func onResizeRequest(_ handler: ((ResizeEvent) -> Void)?) -> some Surface {
        self.modifier { store in
            store[ResizeRequestKey.self] = handler
        }
    }
}
