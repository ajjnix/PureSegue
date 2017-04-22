import UIKit

public typealias UIViewController_PRSConfigurate = (UIStoryboardSegue) -> ()

protocol PRSSegueRepository {
    func configurate(for identifier: String) -> UIViewController_PRSConfigurate?
    func saveConfigurate(_ configurate: @escaping UIViewController_PRSConfigurate, for identifier: String)
    func removeConfigurate(for identifier: String)
}

final class PRSInMemotySegueRepository: PRSSegueRepository {
    func configurate(for identifier: String) -> UIViewController_PRSConfigurate? {
        return dictionary[identifier]
    }
    
    func saveConfigurate(_ configurate: @escaping UIViewController_PRSConfigurate, for identifier: String) {
        dictionary[identifier] = configurate
    }
    
    func removeConfigurate(for identifier: String) {
        dictionary.removeValue(forKey: identifier)
    }
    
    private var dictionary: [String : UIViewController_PRSConfigurate] = [:]
}
