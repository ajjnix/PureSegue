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
    
    func test_save_configurate() {
        repository.saveConfigurate({ _ in }, for: token)
        let configurate = repository.configurate(for: token)
        XCTAssertNotNil(configurate)
    }
    
    func test_save_correct() {
        let counter = PRSCounter()
        let segue = UIStoryboardSegue(identifier: nil, source: UIViewController(), destination: UIViewController())
        let mockConfigurate: UIViewController_PRSConfigurate = { _ in
            counter.increment()
        }
        
        repository.saveConfigurate(mockConfigurate, for: token)
        let configurate = repository.configurate(for: token)
        configurate?(segue)
        
        XCTAssertEqual(counter.count, 1)
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
