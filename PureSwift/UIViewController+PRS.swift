import UIKit
import ObjectiveC

extension UIViewController {
    private enum Key {
        static let token: String = #file + "#(Key.token)"
        static var segueRepository = #file + "#(segueRepository)"
    }
    
    public func prs_performSegue<T>(to clazz: T.Type, sender: AnyObject? = nil, configurate: ((T?) -> ())? = nil)
        where T: UIViewController {
            let identifier = String(describing: clazz)
            prs_performSegue(withIdentifier: identifier, sender: sender, configurate: { segue in
                let viewController = segue.destination as? T
                configurate?(viewController)
            })
    }
    
    public func prs_performSegue(withIdentifier identifier: String,
                                 sender: AnyObject? = nil,
                                 configurate: @escaping UIViewController_PRSConfigurate) {
        prs_swizzlingPrepareForSegue()
        prs_segueRepository.saveConfigurate(configurate, for: identifier)
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    private func prs_swizzlingPrepareForSegue() {
        DispatchQueue.prs_once(token: Key.token, function: {
            let originalSelector = #selector(UIViewController.prepare(for:sender:))
            let swizzledSelector = #selector(UIViewController.prs_prepare(for:sender:))
            
            let clazz = UIViewController.self
            let originalMethod = class_getInstanceMethod(clazz, originalSelector)
            let swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector)

            method_exchangeImplementations(originalMethod, swizzledMethod)
        })
    }
    
    @objc private func prs_prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            prs_prepare(for: segue, sender: sender)
            return
        }

        prs_segueRepository.configurate(for: identifier)?(segue)
        prs_prepare(for: segue, sender: sender)
        prs_segueRepository.removeConfigurate(for: identifier)
    }
    
    private var prs_segueRepository: PRSSegueRepository {
        get {
            let box = objc_getAssociatedObject(self, &Key.segueRepository) as? PRSBox
            guard let repository = box?.value as? PRSSegueRepository else {
                let repository = PRSInMemotySegueRepository()
                self.prs_segueRepository = repository
                return repository
            }
            return repository
        }
        set {
            objc_setAssociatedObject(self, &Key.segueRepository, PRSBox(newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
