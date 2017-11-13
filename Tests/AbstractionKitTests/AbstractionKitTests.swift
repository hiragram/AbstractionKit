import XCTest
@testable import AbstractionKit

class AbstractionKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AbstractionKit().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
