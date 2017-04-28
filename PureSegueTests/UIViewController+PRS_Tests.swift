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
    }
    
    func test_short_performSegue_correct_argument() {
        let mockViewController = PRS_Mock_ViewController()
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { _ in })
        XCTAssertEqual(mockViewController.spy_performSegue?.identifier, TestData.identifier)
        XCTAssertNil(mockViewController.spy_performSegue?.sender)
    }
    
    func test_full_performSegue_correct_argument() {
        let mockViewController = PRS_Mock_ViewController()
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, sender: self, configurate: { _ in })

        XCTAssertEqual(mockViewController.spy_performSegue?.identifier, TestData.identifier)
        XCTAssertNotNil(mockViewController.spy_performSegue?.sender)
        XCTAssertTrue(mockViewController.spy_performSegue!.sender is UIViewController_PRS_Tests)
        XCTAssertTrue((mockViewController.spy_performSegue!.sender as! UIViewController_PRS_Tests) === self)
    }
    
    func test_performSegue_not_called_configurate_without_segue_identifier() {
        let mockViewController = PRS_Mock_ViewController()
        mockViewController.stub_segue.stub_identifier = nil
        
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { _ in })
        XCTAssertNil(mockViewController.spy_configurate_segue)
    }
    
    func test_performSegue_called_configurate_correct() {
        let segue = PRS_Stub_StoryboardSegue()
        let mockViewController = PRS_Mock_ViewController(stub_segue: segue)
        mockViewController.prs_performSegue(withIdentifier: TestData.identifier, configurate: { _ in })
        XCTAssertNotNil(mockViewController.spy_configurate_segue)
        XCTAssertTrue(mockViewController.spy_configurate_segue! === segue)
    }
    
    func test_performSegue_to_class() {
        let dummy_viewController = PRS_Dummy_ViewController()
        let clazz = type(of: dummy_viewController)
        let segue = PRS_Stub_StoryboardSegue(stub_identifier: String(describing: clazz),
                                             stub_destination: dummy_viewController)
        
        let mockViewController = PRS_Mock_ViewController(stub_segue: segue)
        var spy_viewController: UIViewController? = nil
        mockViewController.prs_performSegue(to: clazz, sender: nil, configurate: { viewController in
            spy_viewController = viewController
        })
        
        XCTAssertNotNil(spy_viewController)
        XCTAssertTrue(spy_viewController! === dummy_viewController)
    }
    
    func test_performSegue_to_class_fail() {
        let dummy_viewController = PRS_Dummy_ViewController()
        let clazz = type(of: dummy_viewController)
        let segue = PRS_Stub_StoryboardSegue(stub_identifier: String(describing: clazz))
        
        let mockViewController = PRS_Mock_ViewController(stub_segue: segue)
        var spy_viewController: UIViewController? = nil
        mockViewController.prs_performSegue(to: clazz, sender: nil, configurate: { viewController in
            spy_viewController = viewController
        })
        
        XCTAssertNil(spy_viewController)
    }
}

final class PRS_Mock_ViewController: UIViewController {
    let stub_segue: PRS_Stub_StoryboardSegue
    
    init(stub_segue: PRS_Stub_StoryboardSegue = .init()) {
        self.stub_segue = stub_segue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    private(set) var spy_performSegue: (identifier: String, sender: Any?)? = nil
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        spy_performSegue = (identifier, sender)
        prepare(for: stub_segue, sender: sender)
    }
    
    private(set) var spy_configurate_segue: UIStoryboardSegue?
    override func prs_performSegue(withIdentifier identifier: String, sender: Any?, configurate: @escaping UIViewController_PRSConfigurate) {
        super.prs_performSegue(withIdentifier: identifier, sender: sender, configurate: { segue in
            self.spy_configurate_segue = segue
            configurate(segue)
        })
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

final class PRS_Dummy_ViewController: UIViewController {
}
