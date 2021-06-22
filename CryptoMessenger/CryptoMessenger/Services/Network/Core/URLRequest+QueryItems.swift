import Foundation

// MARK: - URLRequest ()

extension URLRequest {

    // MARK: - Internal Methods

    mutating func addQueryItems(_ items: [URLQueryItem]) {
        guard let url = self.url, !items.isEmpty else { return }
        var cmps = URLComponents(string: url.absoluteString)
        let currentItems = cmps?.queryItems ?? []
        cmps?.queryItems = currentItems + items
        self.url = cmps?.url
    }
}
