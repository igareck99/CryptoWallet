import SwiftUI

// MARK: - AdressesData

struct AdressesData {

    // MARK: - Internal Properties

    var eth: String?
    var btc: String?
    var bnc: String?
    var aur: String?

    // MARK: - Internal Methods

    func getDataForPatchAssets() -> [String: [String: String]] {
        var params = [String: [String: String]]()
        if let ethAddress = eth {
            params["ethereum"] = ["address": ethAddress]
        }
        if let btcAddress = btc {
            params["bitcoin"] = ["address": btcAddress]
        }
        if let bncAddress = bnc {
            params["binance"] = ["address": bncAddress]
        }
        if let auraAdress = aur {
            params["aura"] = ["address": auraAdress]
        }
        debugPrint("AdressesData.getDataForPatchAssets: \(params)")
        return params
    }
}
