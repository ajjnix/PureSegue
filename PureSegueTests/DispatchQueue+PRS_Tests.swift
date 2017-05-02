import XCTest
@testable import PureSegue

final class DispatchQueue_RPS_Tests: XCTestCase {
    func test_first_true() {
        let repository = PRS_Stub_TokenRepository(stub_contains: false)
        let result = DispatchQueue.prs_once(token: "token", tokenRepository: repository, function: {})
        XCTAssertTrue(result)
    }
    
    func test_second_false() {
        let token = "token"
        let repository = PRS_Stub_TokenRepository(stub_contains: true)
        let result = DispatchQueue.prs_once(token: token, tokenRepository: repository, function: {})
        XCTAssertFalse(result)
    }
    
    func test_exec_contains_token_false() {
        let token = "token"
        var count = 0
        let increment = {
            count += 1
        }
        let repository = PRS_Stub_TokenRepository(stub_contains: false)
        
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: increment)
        
        XCTAssertEqual(count, 3)
    }
    
    func test_exec_contains_token_true() {
        let token = "token"
        var count = 0
        let increment = {
            count += 1
        }
        let repository = PRS_Stub_TokenRepository(stub_contains: true)
        
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: increment)
        
        XCTAssertEqual(count, 0)
    }
}

private final class PRS_Stub_TokenRepository: PRSTokenRepository {
    init(stub_contains: Bool) {
        self.stub_contains = stub_contains
    }
    
    func contains(_ token: String) -> Bool {
        return stub_contains
    }
    
    func append(_ token: String) {
    }
    
    private let stub_contains: Bool
}
