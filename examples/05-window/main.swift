import Blusher

struct BlueRectangle: View {
    @State var blue: Float = 1.0

    var body: some View {
        Rectangle()
            .geometry(Rect(x: 50.0, y: 10.0, width: 30.0, height: 30.0))
            .color(Color(r: 0.0, g: 0.0, b: blue, a: 1.0))
            .onPointerEnter { _ in
                blue -= 0.2
            }
    }
}

@main
struct WindowApp: Application {
    var body: some Surface {
        Window {
            Rectangle()
                .geometry(Rect(x: 10.0, y: 10.0, width: 20.0, height: 20.0))
                .color(Color(r: 1.0, g: 0.0, b: 0.0, a: 1.0))
                .onPointerEnter { event in
                    print(event)
                }
            Rectangle()
                .geometry(Rect(x: 30.0, y: 10.0, width: 30.0, height: 30.0))
                .color(Color(r: 0.0, g: 0.0, b: 0.0, a: 1.0))
            BlueRectangle()
            Image(path: "swingby.png")
                .geometry(Rect(x: 10.0, y: 10.0, width: 340.0, height: 150.0))
        }
        .size(SizeI(width: 300, height: 200))
    }

    public static func main() {
        let _ = self.applicationMain()
    }
}
