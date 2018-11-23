import XCTest
@testable import Observer

final class ObserverTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Observer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
