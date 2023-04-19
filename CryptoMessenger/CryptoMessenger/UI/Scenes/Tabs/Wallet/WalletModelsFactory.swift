import Foundation

protocol WalletModelsFactoryProtocol {
    static func makeBalanceRequestParamsV2(
        wallets: [WalletNetwork],
        networkTokens: [NetworkToken]
    ) -> BalanceRequestParamsV2

    static func makeDisplayCards(
        wallets: [WalletNetwork],
        tokens: [NetworkToken]
    ) -> [WalletInfo]

    static func makeAddressRequestParams(
        keychainService: KeychainServiceProtocol
    ) -> AddressRequestParams
    
    static func makeAdressesData(
        wallets: [WalletNetwork]
    ) -> [String: [String : String]]
}

enum WalletModelsFactory {}

// MARK: - WalletModelsFactoryProtocol

extension WalletModelsFactory: WalletModelsFactoryProtocol {
    static func makeBalanceRequestParamsV2(
        wallets: [WalletNetwork],
        networkTokens: [NetworkToken]
    ) -> BalanceRequestParamsV2 {
        var addresses = [NetworkAddress: [WalletBalanceAddress]]()

        if let bitcoinAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue })?.address,
           bitcoinAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.contractType == CryptoType.bitcoin.rawValue }
                .map { .init(accountAddress: bitcoinAddress, tokenAddress: $0.address) }
            addresses[.bitcoin] = [WalletBalanceAddress(accountAddress: bitcoinAddress)] + tokenAddresses
        }

        if let ethereumAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.ethereum.rawValue })?.address,
           ethereumAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.contractType == CryptoType.ethereum.rawValue }
                .map { .init(accountAddress: ethereumAddress, tokenAddress: $0.address) }
            addresses[.ethereum] = [WalletBalanceAddress(accountAddress: ethereumAddress)] + tokenAddresses
        }

        if let binanceAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.binance.rawValue })?.address,
           binanceAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.contractType == CryptoType.binance.rawValue }
                .map { .init(accountAddress: binanceAddress, tokenAddress: $0.address) }
            addresses[.binance] = [WalletBalanceAddress(accountAddress: binanceAddress)] + tokenAddresses
        }

        let params = BalanceRequestParamsV2(currency: .usd, addresses: addresses)
        return params
    }

    static func makeDisplayCards(
        wallets: [WalletNetwork],
        tokens: [NetworkToken]
    ) -> [WalletInfo] {

        var cards = [WalletInfo]()
        wallets.forEach { wallet in
            guard let cryptoType = wallet.cryptoType,
                  let walletType = WalletType(rawValue: cryptoType) else { return }

            let fiat = wallet.fiatPrice * ((wallet.balance as? NSString)?.doubleValue ?? 1)
            let fiatAmount = String(format: "%.2f", fiat)
            let walletCard = WalletInfo(
                decimals: Int(wallet.decimals),
                walletType: walletType,
                address: wallet.address ?? "",
                coinAmount: wallet.balance ?? "0",
                fiatAmount: fiatAmount
            )
            cards.append(walletCard)

            tokens
                .filter { token in token.network == cryptoType && walletType != .bitcoin }
                .forEach { token in
                    let fiat = token.fiatPrice * ((token.balance as? NSString)?.doubleValue ?? 1)
                    let fiatAmount = String(format: "%.2f", fiat)
                    let tokenWalletType = WalletType(rawValue: cryptoType + (token.symbol ?? ""))

                    let tokenCard = WalletInfo(
                        decimals: Int(token.decimals),
                        walletType: tokenWalletType ?? walletType,
                        address: wallet.address ?? "",
                        tokenAddress: token.address ?? "",
                        coinAmount: token.balance ?? "0",
                        fiatAmount: fiatAmount
                    )
                    cards.append(tokenCard)
                }
        }
        return cards
    }

    static func makeAddressRequestParams(keychainService: KeychainServiceProtocol) -> AddressRequestParams {

        var ethereum = [WalletPublic]()
        if let publicKey: String = keychainService[.ethereumPublicKey] {
            ethereum.append(WalletPublic(publicKey: publicKey))
        }

        var bitcoin = [WalletPublic]()
        if let publicKey: String = keychainService[.bitcoinPublicKey] {
            bitcoin.append(WalletPublic(publicKey: publicKey))
        }

        var binance = [WalletPublic]()
        if let publicKey: String = keychainService[.binancePublicKey] {
            binance.append(WalletPublic(publicKey: publicKey))
        }

        let params = AddressRequestParams(
            ethereum: ethereum,
            bitcoin: bitcoin,
            binance: binance
        )

        return params
    }

    static func makeAdressesData(wallets: [WalletNetwork]) -> [String: [String: String]] {
        let ethAddress = wallets.first(where: { $0.cryptoType == CryptoType.ethereum.rawValue })?.address   // ETH, USDT, USDC
        let btcAddress = wallets.first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue })?.address    // BTC
        let bncAddress = wallets.first(where: { $0.cryptoType == CryptoType.binance.rawValue })?.address    // BNB, USDT, USDC

        let adressesData = AdressesData(
            eth: ethAddress,
            btc: btcAddress,
            bnc: bncAddress
        ).getDataForPatchAssets()

        return adressesData
    }
}
