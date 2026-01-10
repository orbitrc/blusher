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
