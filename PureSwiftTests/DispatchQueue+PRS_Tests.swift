import XCTest
@testable import PureSwift

final class DispatchQueue_RPS_Tests: XCTestCase {
    func test_result_exec_first() {
        let repository = PRS_Stub_TokenRepository(stub_contains: false)
        let result = DispatchQueue.prs_once(token: "token", tokenRepository: repository, function: {})
        XCTAssertTrue(result)
    }
    
    func test_result_exec_second() {
        let token = "token"
        let repository = PRS_Stub_TokenRepository(stub_contains: true)
        let result = DispatchQueue.prs_once(token: token, tokenRepository: repository, function: {})
        XCTAssertFalse(result)
    }
    
    func test_exec_contains_token_false() {
        let token = "token"
        let counter = PRSCounter()
        let repository = PRS_Stub_TokenRepository(stub_contains: false)
        
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: counter.increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: counter.increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: counter.increment)
        
        XCTAssertEqual(counter.count, 3)
    }
    
    func test_exec_contains_token_true() {
        let token = "token"
        let counter = PRSCounter()
        let repository = PRS_Stub_TokenRepository(stub_contains: true)
        
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: counter.increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: counter.increment)
        DispatchQueue.prs_once(token: token, tokenRepository: repository, function: counter.increment)
        
        XCTAssertEqual(counter.count, 0)
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
