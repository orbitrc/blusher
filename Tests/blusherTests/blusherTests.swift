import Testing
@testable import Blusher

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func rectEquatable() async throws {
    let rect1 = Rect(x: 0.0, y: 0.0, width: 15.0, height: 15.0)
    let rect2 = Rect(x: 0.0, y: 0.0, width: 15.0, height: 15.0)

    assert(rect1 == rect2)
}

@Test func colorEquatable() async throws {
    let white = Color(r: 255, g: 255, b: 255, a: 255)
    let black = Color(r: 0, g: 0, b: 0, a: 255)

    #expect(white != black)
}

@Test func fileSystem() async throws {
    let file = FileSystem.File.open("Package.swift", "rb")
    let bytes = file.readAll()
    file.close()

    let _ = bytes
}
