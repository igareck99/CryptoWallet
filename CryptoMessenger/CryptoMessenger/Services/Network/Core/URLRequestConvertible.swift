import Foundation

// MARK: URLRequestConvertible

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
