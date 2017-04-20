protocol PRSTokenRepository {
    func contains(_ token: String) -> Bool
    func append(_ token: String)
}

final class PRSInMemotyTokenRepository: PRSTokenRepository {
    func contains(_ token: String) -> Bool {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        return tokens.contains(token)
    }
    
    func append(_ token: String) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        tokens.append(token)
    }
    
    private var tokens: [String] = []
}
