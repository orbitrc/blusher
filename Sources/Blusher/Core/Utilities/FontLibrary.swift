@_implementationOnly import CFontconfig

public class FontLibrary {
    nonisolated(unsafe) public static var shared: FontLibrary!

    private init() {
        FcInit()

        FontLibrary.shared = self
    }

    deinit {
        FcFini()
    }

    public static func findFont(family: String) -> Font {
        var font = Font()

        let pattern = FcPatternCreate()

        family.withCString { cStr in
            let _ = FcPatternAddString(pattern, FC_FAMILY, cStr)
        }
        FcConfigSubstitute(nil, pattern, FcMatchPattern)
        FcDefaultSubstitute(pattern)

        var result = FcResultNoMatch
        let match = FcFontMatch(nil, pattern, &result)

        FcPatternDestroy(pattern)

        // if result != FcResultMatch

        var path: UnsafeMutablePointer<FcChar8>? = nil
        var index: Int32 = 0
        var weight: Int32 = 0
        var size = 1.0

        FcPatternGetString(match, FC_FILE, 0, &path)
        FcPatternGetInteger(match, FC_INDEX, 0, &index)
        FcPatternGetInteger(match, FC_WEIGHT, 0, &weight)
        FcPatternGetDouble(match, FC_PIXEL_SIZE, 0, &size)

        font.path = String(cString: path!)
        font.ttcIndex = Int(index)
        font.size = Float(size)

        return font
    }
}
