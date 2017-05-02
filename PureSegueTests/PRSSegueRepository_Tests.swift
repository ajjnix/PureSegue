import XCTest
import UIKit
@testable import PureSegue

final class PRSPRSSegueRepository_Tests: XCTestCase {
    override func setUp() {
        super.setUp()
        repository = PRSInMemotySegueRepository()
    }
    
    func test_configurate_none() {
        let configurate = repository.configurate(for: token)
        XCTAssertNil(configurate)
    }
    
    func test_save_correct() {
        var called = false
        repository.saveConfigurate({ _ in
            called = true
        }, for: token)
        
        let configurate = repository.configurate(for: token)
        configurate?(PRS_Stub_StoryboardSegue())
        
        XCTAssertTrue(called)
    }
    
    func test_remove_configurate() {
        repository.saveConfigurate({ _ in }, for: token)
        repository.removeConfigurate(for: token)
        let configurate = repository.configurate(for: token)
        XCTAssertNil(configurate)
    }
    
    private let token = "token"
    private var repository: PRSInMemotySegueRepository!
}
