import Blusher

let app = ApplicationHandle(CommandLine.arguments)

let surface = SurfaceHandle(role: .toplevel)

surface.show()

app.exec()
