import Blusher

let app = BApplication(CommandLine.arguments)

let window = BWindow()
window.size = SizeI(width: 500, height: 400)

let imageFile = FileSystem.File.open("swingby.png", "rb")
let data = imageFile.readAll()

let image = ImageHandle(from: data)

let view = BView(
    parent: window.body,
    geometry: Rect(x: 0.0, y: 0.0, width: 340.0, height: 150.0)
)

view.renderType = .image
view.image = image

window.show()

app.exec()
