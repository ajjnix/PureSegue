import XCTest
@testable import PureSwift

final class PRSBox_Tests: XCTestCase {
    func test_save_value() {
        let value = 123
        let box = PRSBox(value)
        XCTAssertNotNil(box.value)
        let boxInt = box.value as? Int
        XCTAssertNotNil(boxInt)
        XCTAssertEqual(boxInt, value)
    }
    
    func test_save_nil() {
        let box = PRSBox(nil)
        XCTAssertNil(box.value)
    }
}
