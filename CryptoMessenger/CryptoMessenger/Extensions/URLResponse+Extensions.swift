import Foundation

extension URLResponse {
    var isSuccess: Bool {
        (200 ... 299).contains(code)
    }

    var isRefreshNeeded: Bool {
        code == 401
    }

    var code: Int {
        (self as? HTTPURLResponse)?.statusCode ?? -1
    }
}
