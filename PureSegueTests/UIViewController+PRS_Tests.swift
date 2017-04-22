import XCTest
import UIKit
@testable import PureSegue

private enum TestData {
    static let identifier = "identifier"
}

final class UIViewController_PRS_Tests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        counter = PRSCounter()
        mockViewController = PRS_Mock_ViewController()
    }
    
    func test_short_performSegue_correct_argument() {
        mockViewController.before_performSegue = { identifier, sender in
            XCTAssertEqual(TestData.identifier, identifier)
            XCTAssertNil(sender)
            self.counter.increment()
        }
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { _ in })
        XCTAssertEqual(counter.count, 1)
    }
    
    func test_full_performSegue_correct_argument() {
        mockViewController.before_performSegue = { identifier, sender in
            XCTAssertEqual(TestData.identifier, identifier)
            XCTAssertNotNil(sender)
            XCTAssertTrue(sender is UIViewController_PRS_Tests)
            XCTAssertTrue((sender as! UIViewController_PRS_Tests) === self)
            self.counter.increment()
        }
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, sender: self, configurate: { _ in })
        XCTAssertEqual(counter.count, 1)
    }
    
    func test_performSegue_called_configurate() {
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { segue in
            self.counter.increment()
        })
        XCTAssertEqual(counter.count, 1)
    }
    
    func test_performSegue_not_called_configurate_without_segue_identifier() {
        mockViewController.stub_segue.stub_identifier = nil
        
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { segue in
            self.counter.increment()
        })
        
        XCTAssertEqual(counter.count, 0)
    }
    
    func test_performSegue_called_configurate_correct() {
        var verify = false
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { segue in
            verify = (segue === self.mockViewController.stub_segue)
        })
        XCTAssertTrue(verify)
    }
    
    func test_performSegue_to_class() {
        let fake_viewController = PRS_Fake_ViewController()
        let clazz = type(of: fake_viewController)
        mockViewController.stub_segue.stub_identifier = String(describing: clazz)
        mockViewController.stub_segue.stub_destination = fake_viewController
        
        mockViewController.prs_performSegue(to: clazz, sender: nil, configurate: { viewController in
            self.counter.increment()
            XCTAssertNotNil(viewController)
            XCTAssertTrue(viewController === fake_viewController)
        })
        
        XCTAssertEqual(counter.count, 1)
    }
    
    func test_performSegue_to_class_fail() {
        let fake_viewController = PRS_Fake_ViewController()
        let clazz = type(of: fake_viewController)
        mockViewController.stub_segue.stub_identifier = String(describing: clazz)
        mockViewController.stub_segue.stub_destination = UIViewController()
        
        mockViewController.prs_performSegue(to: clazz, sender: nil, configurate: { viewController in
            self.counter.increment()
            XCTAssertNil(viewController)
        })
        
        XCTAssertEqual(counter.count, 1)
    }
    
    private var counter: PRSCounter!
    private var mockViewController: PRS_Mock_ViewController!
}

final class PRS_Mock_ViewController: UIViewController {
    var stub_segue = PRS_Stub_StoryboardSegue()

    var before_performSegue: (String, Any?) -> () = { _ in }
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        before_performSegue(identifier, sender)
        prepare(for: stub_segue, sender: sender)
    }
}

final class PRS_Stub_StoryboardSegue: UIStoryboardSegue {
    init(stub_identifier: String = TestData.identifier,
         stub_source: UIViewController = .init(nibName: nil, bundle: nil),
         stub_destination: UIViewController = .init(nibName: nil, bundle: nil)) {
        self.stub_identifier = stub_identifier
        self.stub_destination = stub_destination
        super.init(identifier: stub_identifier, source: stub_source, destination: stub_destination)
    }
    
    var stub_identifier: String?
    override var identifier: String? {
        return stub_identifier
    }
    
    var stub_destination: UIViewController
    override var destination: UIViewController {
        return stub_destination
    }
}

final class PRS_Fake_ViewController: UIViewController {
}
