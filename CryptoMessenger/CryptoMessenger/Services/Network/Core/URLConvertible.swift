import Foundation

// MARK: - URLConvertible

protocol URLConvertible {
    func asURL() throws -> URL
}

// MARK: - String (URLConvertible)

extension String: URLConvertible {
    func asURL() -> URL {
        guard let url = URL(string: self) else { fatalError("URLConvertible failed") }
        return url
    }
}
