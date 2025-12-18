import Blusher

@main
struct ExampleApp: Application {
    var body: some Surface {
        ToplevelSurface {
            Rectangle()
                .color(Color(r: 255, g: 0, b: 0, a: 255))
        }
    }

    public static func main() {
        self.applicationMain()
    }
}
