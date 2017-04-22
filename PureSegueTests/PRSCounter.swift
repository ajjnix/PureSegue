import XCTest

final class PRSCounter {
    var count: Int = 0
    func increment() {
        count += 1
    }
}

final class RPSCounter_Tests: XCTestCase {
    func test_init_zero() {
        let counter = PRSCounter()
        XCTAssertEqual(counter.count, 0)
    }
    
    func test_increment_1() {
        let counter = PRSCounter()
        counter.increment()
        XCTAssertEqual(counter.count, 1)
    }
    
    func test_increment_2() {
        let counter = PRSCounter()
        counter.increment()
        counter.increment()
        XCTAssertEqual(counter.count, 2)
    }
}
