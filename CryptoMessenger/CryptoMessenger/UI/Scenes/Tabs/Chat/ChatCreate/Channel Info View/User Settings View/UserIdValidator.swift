import Foundation

enum UserIdValidator {
    static func makeValidId(userId: String) -> String? {
        
        let config = Configuration()
        let urlComponents = NSURLComponents(string: config.matrixURL.absoluteString)
        guard let host = urlComponents?.host else { return nil }
        
        var mUserId = userId
        
        if !userId.starts(with: "@") {
            mUserId = "@" + mUserId
        }
            
        if !userId.contains(host) {
            mUserId = "@" + host
        }
        
        return mUserId
    }
}
