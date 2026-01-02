import Blusher

struct BlueRectangle: View {
    @State var blue: UInt8 = 255

    var body: some View {
        Rectangle()
            .geometry(Rect(x: 50.0, y: 10.0, width: 30.0, height: 30.0))
            .color(Color(r: 0, g: 0, b: blue, a: 255))
            .onPointerEnter { _ in
                blue = 100
            }
            .onPointerMove { _ in
                SurfaceHandle.current?.startMove()
            }
    }
}

@main
struct WindowApp: Application {
    var body: some Surface {
        Window {
            Rectangle()
                .geometry(Rect(x: 10.0, y: 10.0, width: 20.0, height: 20.0))
                .color(Color(r: 255, g: 0, b: 0, a: 255))
                .onPointerEnter { event in
                    print(event)
                }
            Rectangle()
                .geometry(Rect(x: 30.0, y: 10.0, width: 30.0, height: 30.0))
                .color(Color(r: 0, g: 255, b: 0, a: 255))
            BlueRectangle()
        }
    }

    public static func main() {
        let _ = self.applicationMain()
    }
}
