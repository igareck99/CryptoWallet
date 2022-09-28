struct MXURL {

    // MARK: - Internal Properties

    var mxContentURI: URL

    // MARK: - Life Cycle

    init?(mxContentURI: String) {
        guard let uri = URL(string: mxContentURI) else {
            return nil
        }
        self.mxContentURI = uri
    }

    // MARK: - Internal Methods

    func contentURL(on homeserver: URL) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = homeserver.host
        guard let contentHost = mxContentURI.host else { return nil }
        components.path = "/_matrix/media/r0/download/\(contentHost)/\(mxContentURI.lastPathComponent)"
        return components.url
    }
}
