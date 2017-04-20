protocol PRSTokenRepository {
    func contains(_ token: String) -> Bool
    func append(_ token: String)
}

extension DispatchQueue {
    @discardableResult
    static func prs_once(token: String, tokenRepository: PRSTokenRepository, function: () -> ()) -> Bool {
        guard tokenRepository.contains(token) == false else {
            return false
        }
        tokenRepository.append(token)
        function()
        return true
    }
}
