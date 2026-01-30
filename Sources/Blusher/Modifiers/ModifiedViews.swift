//===============
// Property
//===============

protocol _PropertyModifiedView {
    var innerContent: any View { get }

    func apply(_: inout PropertyStore) -> Void
}

struct PropertyModifiedView<Content: View>: View, _PropertyModifiedView {
    let content: Content
    let action: (inout PropertyStore) -> Void

    var body: some View {
        content
    }

    var innerContent: any View {
        self.content
    }

    func apply(_ store: inout PropertyStore) {
        self.action(&store)
    }
}

extension View {
    func modifier(_ action: @escaping (inout PropertyStore) -> Void) -> some View {
        PropertyModifiedView(content: self, action: action)
    }
}

//=============
// Children
//=============

protocol _ChildrenModifiedView {
    var innerContent: any View { get }
    var childrenContent: any View { get }
}

struct ChildrenModifiedView<Content: View, Children: View>: View, _ChildrenModifiedView {
    let content: Content
    let children: Children

    var body: some View {
        content
    }

    var innerContent: any View {
        content
    }

    var childrenContent: any View {
        children
    }
}

extension View {
    public func children(@ViewBuilder _ content: () -> some View) -> some View {
        ChildrenModifiedView(content: self, children: content())
    }
}
