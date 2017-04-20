private let tokenRepository = PRSInMemotyTokenRepository()

extension DispatchQueue {
    @discardableResult
    static func prs_once(token: String, tokenRepository: PRSTokenRepository = tokenRepository, function: () -> ()) -> Bool {
        guard tokenRepository.contains(token) == false else {
            return false
        }
        tokenRepository.append(token)
        function()
        return true
    }
}
