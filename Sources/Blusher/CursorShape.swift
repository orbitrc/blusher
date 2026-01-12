@_implementationOnly import Swingby

public enum CursorShape {
    case none
    /// Default arrow cursor.
    case `default`
    /// Context menu arrow. Menu icon next to the arrow.
    case contextMenu
    /// Question mark in a circle next to the arrow.
    case help
    /// Finger pointing hand.
    case pointer
    /// Arrow cursor with animated waiting indicator.
    case progress
    /// Animated waiting indicator.
    case wait
    /// Thick cross.
    case cell
    /// Thin cross.
    case crosshair
    /// I-Beam shape.
    case text
    /// Vertical I-Beam shape.
    case verticalText
    /// Curved arrow sign next to the arrow.
    case alias
    /// Copy arrow. Plus sign next to the arrow.
    case copy
    /// Top, bottom, left and right arrow or same as grabbing.
    case move
    /// Arrow with crossed circle.
    case noDrop
    /// Red circle with diagonal in the circle.
    case notAllowed
    /// Open hand.
    case grab
    /// Closed hand.
    case grabbing
    /// Resize arrow pointing right.
    case eResize
    /// Risize arrow pointing top.
    case nResize
    /// Resize arrow pointing top right.
    case neResize
    /// Resize arrow pointing top left.
    case nwResize
    /// Resize arrow pointing bottom.
    case sResize
    /// Resize arrow pointing bottom right.
    case seResize
    /// Resize arrow pointing bottom left,
    case swResize
    /// Resize arrow pointing left.
    case wResize
    /// Resize arrow pointing both left and right.
    case ewResize
    /// Resize arrow pointing both top and bottom.
    case nsResize
    /// Resize arrow pointing both top right and bottom left.
    case neswResize
    /// Resize arrow pointing both top left and bottom right.
    case nwseResize
    /// Two arrows for left and right with a vertical bar.
    case colResize
    /// Tow arrows for top and bottom with a horizontal bar.
    case rowResize
    /// Four arrows for top, left, right and bottom with a dot in center.
    case allScroll
    /// Magnifier with plus sign.
    case zoomIn
    /// Magnifier with minus sign.
    case zoomOut
}

internal extension CursorShape {
    static func toSwingbyCursorShape(_ shape: CursorShape) -> sb_cursor_shape {
        switch shape {
        case .none: return SB_CURSOR_SHAPE_NONE
        case .default: return SB_CURSOR_SHAPE_DEFAULT
        case .contextMenu: return SB_CURSOR_SHAPE_CONTEXT_MENU
        case .help: return SB_CURSOR_SHAPE_HELP
        case .pointer: return SB_CURSOR_SHAPE_POINTER
        case .progress: return SB_CURSOR_SHAPE_PROGRESS
        case .wait: return SB_CURSOR_SHAPE_WAIT
        case .cell: return SB_CURSOR_SHAPE_CELL
        case .crosshair: return SB_CURSOR_SHAPE_CROSSHAIR
        case .text: return SB_CURSOR_SHAPE_TEXT
        case .verticalText: return SB_CURSOR_SHAPE_VERTICAL_TEXT
        case .alias: return SB_CURSOR_SHAPE_ALIAS
        case .copy: return SB_CURSOR_SHAPE_COPY
        case .move: return SB_CURSOR_SHAPE_MOVE
        case .noDrop: return SB_CURSOR_SHAPE_NO_DROP
        case .notAllowed: return SB_CURSOR_SHAPE_NOT_ALLOWED
        case .grab: return SB_CURSOR_SHAPE_GRAB
        case .grabbing: return SB_CURSOR_SHAPE_GRABBING
        case .eResize: return SB_CURSOR_SHAPE_E_RESIZE
        case .nResize: return SB_CURSOR_SHAPE_N_RESIZE
        case .neResize: return SB_CURSOR_SHAPE_NE_RESIZE
        case .nwResize: return SB_CURSOR_SHAPE_NW_RESIZE
        case .sResize: return SB_CURSOR_SHAPE_S_RESIZE
        case .seResize: return SB_CURSOR_SHAPE_SE_RESIZE
        case .swResize: return SB_CURSOR_SHAPE_SW_RESIZE
        case .wResize: return SB_CURSOR_SHAPE_W_RESIZE
        case .ewResize: return SB_CURSOR_SHAPE_EW_RESIZE
        case .nsResize: return SB_CURSOR_SHAPE_NS_RESIZE
        case .neswResize: return SB_CURSOR_SHAPE_NESW_RESIZE
        case .nwseResize: return SB_CURSOR_SHAPE_NWSE_RESIZE
        case .colResize: return SB_CURSOR_SHAPE_COL_RESIZE
        case .rowResize: return SB_CURSOR_SHAPE_ROW_RESIZE
        case .allScroll: return SB_CURSOR_SHAPE_ALL_SCROLL
        case .zoomIn: return SB_CURSOR_SHAPE_ZOOM_IN
        case .zoomOut: return SB_CURSOR_SHAPE_ZOOM_OUT
        }
    }
}
