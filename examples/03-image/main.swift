import Blusher

let app = ApplicationHandle(CommandLine.arguments)

let surface = SurfaceHandle(role: .toplevel)
surface.size = SizeI(width: 500, height: 500)

let imageFile = FileSystem.File.open("swingby.png", "rb")
let data = imageFile.readAll()

let image = ImageHandle(from: data)

let view = ViewHandle(
    surface: surface,
    geometry: Rect(x: 0.0, y: 0.0, width: 340.0, height: 150.0)
)

view.renderType = .image
view.image = image

surface.show()

app.exec()
