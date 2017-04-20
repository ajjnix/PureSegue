import UIKit

public typealias UIViewController_PRSConfigurate = (UIStoryboardSegue) -> ()

protocol PRSSegueRepository {
    func configurate(for identifier: String) -> UIViewController_PRSConfigurate?
    func saveConfigurate(_ configurate: @escaping UIViewController_PRSConfigurate, for identifier: String)
    func removeConfigurate(for identifier: String)
}

final class PRSInMemotySegueRepository: PRSSegueRepository {
    func configurate(for identifier: String) -> UIViewController_PRSConfigurate? {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        return dictionary[identifier]
    }
    
    func saveConfigurate(_ configurate: @escaping UIViewController_PRSConfigurate, for identifier: String) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        dictionary[identifier] = configurate
    }
    
    func removeConfigurate(for identifier: String) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        dictionary.removeValue(forKey: identifier)
    }
    
    private var dictionary: [String : UIViewController_PRSConfigurate] = [:]
}
