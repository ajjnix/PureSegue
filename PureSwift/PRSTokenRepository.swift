protocol PRSTokenRepository {
    func contains(_ token: String) -> Bool
    func append(_ token: String)
}

final class PRSInMemotyTokenRepository: PRSTokenRepository {
    func contains(_ token: String) -> Bool {
        return tokens.contains(token)
    }
    
    func append(_ token: String) {
        tokens.append(token)
    }
    
    private var tokens: [String] = []
}
