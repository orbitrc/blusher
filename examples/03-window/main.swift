import Blusher

class CloseButton: Widget {
    override init(parent: Widget) {
        super.init(parent: parent)
    }

    override func pointerPressEvent(_ event: PointerEvent) {
        print("Close!")
        self.window.close()
    }
}

let app = Application(CommandLine.arguments)

let window = Window()

window.body.color = Color(r: 255, g: 0, b: 0, a: 255)

let closeButton = CloseButton(parent: window.body)
closeButton.size = Size(width: 30.0, height: 30.0)
closeButton.color = Color(r: 0, g: 255, b: 0, a: 255)

window.show()

app.exec()
