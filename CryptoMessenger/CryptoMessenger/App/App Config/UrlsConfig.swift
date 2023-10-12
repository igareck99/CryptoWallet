import Foundation

struct UrlsConfig: Codable {
    let cryptoWallet: String
    let jitsiMeet: String
    let matrixUrl: String
    let apiUrl: String
    let apiVersion: String
    let apiStand: Stand

    static let defaultRelease = UrlsConfig(
        cryptoWallet: "https://crypto.aura.ms/",
        jitsiMeet: "https://meet.aura.ms/",
        matrixUrl: "https://matrix.aura.ms/",
        apiUrl: "https://api.aura.ms/",
        apiVersion: "v0",
        apiStand: .prod
    )

    static let defaultDebug = UrlsConfig(
        cryptoWallet: "https://crypto.auramsg.co/",
        jitsiMeet: "https://meet.auramsg.ms/",
        matrixUrl: "https://matrix.auramsg.co/",
        apiUrl: "https://api.auramsg.co/",
        apiVersion: "v0",
        apiStand: .dev
    )

    enum CodingKeys: String, CodingKey {
        case cryptoWallet = "CryptoWallet"
        case jitsiMeet = "JitsiMeet"
        case matrixUrl = "Matrix"
        case apiUrl = "API"
        case apiVersion = "API Version"
        case apiStand = "apiStand"
    }

    init(
        cryptoWallet: String,
        jitsiMeet: String,
        matrixUrl: String,
        apiUrl: String,
        apiVersion: String,
        apiStand: Stand
    ) {
        self.cryptoWallet = cryptoWallet
        self.jitsiMeet = jitsiMeet
        self.matrixUrl = matrixUrl
        self.apiUrl = apiUrl
        self.apiVersion = apiVersion
        self.apiStand = apiStand
    }

    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(
            UrlsConfig.self,
            from: JSONSerialization.data(withJSONObject: dictionary)
        )
    }
}
