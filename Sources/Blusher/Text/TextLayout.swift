@_implementationOnly import CPango

public struct TextLayout {
    public struct Line {
        private var _runs: [GlyphRun]
    }

    private var _pangoFontMap: UnsafeMutablePointer<PangoFontMap>?
    private var _pangoContext: OpaquePointer?
    private var _pangoLayout: OpaquePointer?
    private var _text: String = ""
    private var _lines: [Line] = []

    public var text: String {
        get { _text }
        set {
            if _text != newValue {
                _text = newValue
                _text.withCString { cStr in
                    pango_layout_set_text(_pangoLayout, cStr, -1)
                }
            }
        }
    }

    public init() {
        _pangoFontMap = pango_ft2_font_map_new()
        _pangoContext = pango_font_map_create_context(_pangoFontMap)
        _pangoLayout = pango_layout_new(_pangoContext)
    }

    public func update() {
        pango_layout_context_changed(_pangoLayout)
    }
}
