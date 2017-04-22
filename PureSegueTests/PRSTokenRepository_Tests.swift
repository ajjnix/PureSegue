import XCTest
@testable import PureSegue

final class PRSTokenRepository_Tests: XCTestCase {
    func test_contains_false() {
        let repository = PRSInMemotyTokenRepository()
        let result = repository.contains("token")
        XCTAssertFalse(result)
    }
    
    func test_append() {
        let repository = PRSInMemotyTokenRepository()
        let token = "token"
        
        repository.append(token)
        let result = repository.contains(token)
        
        XCTAssertTrue(result)
    }
}
