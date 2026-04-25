@_implementationOnly import Swingby

public struct Glyph {
    public var id: UInt32 = 0
    public var advance: Float = 0.0
    public var offset: Point = Point(x: 0.0, y: 0.0)

    public init(id: UInt32) {
        self.id = id
    }
}

public class GlyphRun {
    private var _sbGlyphRun: OpaquePointer? = nil
    private var _glyphBuffer: [Glyph] = []

    public var count: Int {
        return Int(sb_glyph_run_count(_sbGlyphRun))
    }

    public init(count: Int) {
        var sbFont = sb_font_t(path: nil, ttc_index: 0, size: 16.0)
        let path = "/usr/share/fonts/noto/NotoSans-Regular.ttf"
        path.withCString { cStr in
            sbFont.path = cStr
        }
        sbFont.ttc_index = 0

        _sbGlyphRun = sb_glyph_run_new(UInt32(count), &sbFont)

        for _ in 0...count {
            _glyphBuffer.append(Glyph(id: 0))
        }
    }

    deinit {
        sb_glyph_run_free(_sbGlyphRun)
    }

    public subscript(_ index: Int) -> Glyph {
        get {
            return _glyphBuffer[index]
        }
        set {
            _glyphBuffer[index] = newValue

            if let cGlyphs = sb_glyph_run_glyphs(_sbGlyphRun) {
                let cGlyph = cGlyphs + index
                cGlyph.pointee.id = newValue.id
                cGlyph.pointee.advance = newValue.advance
                cGlyph.pointee.offset.x = newValue.offset.x
                cGlyph.pointee.offset.y = newValue.offset.y
            }
        }
    }
}
