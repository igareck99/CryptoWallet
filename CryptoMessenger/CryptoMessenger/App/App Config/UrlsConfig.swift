import Foundation

struct UrlsConfig: Codable {
    let jitsiMeet: String
    let matrixUrl: String
    let apiUrl: String
    let apiVersion: String

    static let defaultRelease = UrlsConfig(
        jitsiMeet: "https://meet.aura.ms",
        matrixUrl: "https://matrix.aura.ms",
        apiUrl: "https://api.aura.ms",
        apiVersion: "v0"
    )

    static let defaultDebug = UrlsConfig(
        jitsiMeet: "https://meet.auramsg.co",
        matrixUrl: "https://matrix.auramsg.co",
        apiUrl: "https://api.auramsg.co",
        apiVersion: "v0"
    )

    enum CodingKeys: String, CodingKey {
        case jitsiMeet = "JitsiMeet"
        case matrixUrl = "Matrix"
        case apiUrl = "API"
        case apiVersion = "API Version"
    }

    init(
        jitsiMeet: String,
        matrixUrl: String,
        apiUrl: String,
        apiVersion: String
    ) {
        self.jitsiMeet = jitsiMeet
        self.matrixUrl = matrixUrl
        self.apiUrl = apiUrl
        self.apiVersion = apiVersion
    }

    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(UrlsConfig.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}
