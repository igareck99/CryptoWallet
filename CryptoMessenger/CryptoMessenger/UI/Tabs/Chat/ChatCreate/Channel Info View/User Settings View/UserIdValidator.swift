import Foundation

// swiftlint: disable: all

enum UserIdValidator {
    static func makeValidId(userId: String) -> String? {
        
        // Пока отключил валидатор т.к. не покрывает кейсы с пользователями из других сетей
        if !userId.isEmpty {
            return userId
        }
        
        guard !tryRegexpMatch(for: userId) else { return userId }
        
        let config = Configuration()
        let urlComponents = NSURLComponents(string: config.matrixURL.absoluteString)
        guard let host = urlComponents?.host else { return nil }
        
        var mUserId = userId
        
        if !userId.starts(with: "@") {
            mUserId = "@" + mUserId
        }
            
        if !userId.contains(host) {
            mUserId += host
        }
        
        return mUserId
    }
    
    static func tryRegexpMatch(for string: String) -> Bool {
        
        let regxpStr = "^@{1}[a-z,A-Z,0-9]{8,256}[:]{1}[a-z,A-Z,0-9]{1,256}[.]{1}[a-z,A-Z,0-9]{1,256}[.]{1}[a-z,A-Z,0-9]{1,256}$"
        
        guard let regExp = try? Regex(regxpStr) else { return false }
        let result = string.wholeMatch(of: regExp)
        return result?.isEmpty == false
    }
}
