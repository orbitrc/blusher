import Blusher

struct BlueRectangle: View {
    var body: some View {
        Rectangle()
            .geometry(Rect(x: 50.0, y: 10.0, width: 30.0, height: 30.0))
            .color(Color(r: 0, g: 0, b: 255, a: 255))
    }
}

@main
struct ExampleApp: Application {
    var body: some Surface {
        ToplevelSurface {
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
