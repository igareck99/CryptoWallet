import Foundation

protocol WalletModelsFactoryProtocol {
    static func makeBalanceRequestParams(
        wallets: [WalletNetwork],
        networkTokens: [NetworkToken]
    ) -> BalanceRequestParams

    static func makeDisplayCards(
        wallets: [WalletNetwork],
        tokens: [NetworkToken]
    ) -> [WalletInfo]

    static func makeAddressRequestParams(
        keychainService: KeychainServiceProtocol
    ) -> AddressRequestParams

    static func makeAdressesData(
        wallets: [WalletNetwork]
    ) -> [String: [String: String]]

    static func makeTransactions(
        networkTokens: [NetworkToken],
        model: WalletsTransactionsResponse
    ) -> TransactionSections

    static func makeTransactionsRequestParams(
        wallets: [WalletAddress]
    ) -> TransactionsRequestParams

    static func makeWalletsAddresses(
        wallets: [WalletNetwork],
        tokens: [NetworkToken]
    ) -> [WalletAddress]

    static func makeTransactionSection(
        address: String,
        networkTokens: [NetworkToken],
        cryptoTransactions: [CryptoTransaction]
    ) -> [TransactionSection]

    static func networkTokenResponseParse(
        response: NetworkTokensResponse
    ) -> [NetworkTokenPonso]
}

enum WalletModelsFactory {}

// MARK: - WalletModelsFactoryProtocol

extension WalletModelsFactory: WalletModelsFactoryProtocol {
    static func makeBalanceRequestParams(
        wallets: [WalletNetwork],
        networkTokens: [NetworkToken]
    ) -> BalanceRequestParams {
        var addresses = [NetworkAddress: [WalletBalanceAddress]]()

        if let bitcoinAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue })?.address,
           bitcoinAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.network == CryptoType.bitcoin.rawValue }
                .map { .init(accountAddress: bitcoinAddress, tokenAddress: $0.address) }
            addresses[.bitcoin] = [WalletBalanceAddress(accountAddress: bitcoinAddress)] + tokenAddresses
        }

        if let ethereumAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.ethereum.rawValue })?.address,
           ethereumAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.network == CryptoType.ethereum.rawValue }
                .map { .init(accountAddress: ethereumAddress, tokenAddress: $0.address) }
            addresses[.ethereum] = [WalletBalanceAddress(accountAddress: ethereumAddress)] + tokenAddresses
        }

        if let binanceAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.binance.rawValue })?.address,
           binanceAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.network == CryptoType.binance.rawValue }
                .map { .init(accountAddress: binanceAddress, tokenAddress: $0.address) }
            addresses[.binance] = [WalletBalanceAddress(accountAddress: binanceAddress)] + tokenAddresses
        }
        
        if let auraAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.aura.rawValue })?.address,
           auraAddress.isEmpty == false {
            let tokenAddresses: [WalletBalanceAddress] = networkTokens
                .filter { $0.network == CryptoType.aura.rawValue }
                .map { .init(accountAddress: auraAddress, tokenAddress: $0.address) }
            addresses[.aura] = [WalletBalanceAddress(accountAddress: auraAddress)] + tokenAddresses
        }

        let params = BalanceRequestParams(currency: .usd, addresses: addresses)
        return params
    }

    static func makeDisplayCards(
        wallets: [WalletNetwork],
        tokens: [NetworkToken]
    ) -> [WalletInfo] {
        var cards = [WalletInfo]()
        wallets.forEach { wallet in
            guard let address = wallet.address,
                  let cryptoType = wallet.cryptoType,
                  let walletType = WalletType(rawValue: cryptoType)
            else {
                return
            }
            print("slaslsal  \(wallet.fiatPrice)  \(wallet.balance)  \(wallet.cryptoType)")
            let fiat = wallet.fiatPrice * ((wallet.balance as? NSString)?.doubleValue ?? 1)
            
            let fiatAmount = String(format: "%.2f", fiat)
            
            let walletCard = WalletInfo(
                decimals: Int(wallet.decimals),
                walletType: walletType,
                address: address,
                coinAmount: wallet.balance ?? "0",
                fiatAmount: fiatAmount
            )
            cards.append(walletCard)

            tokens
                .filter { token in cryptoType != CryptoType.bitcoin.rawValue && token.network == cryptoType }
                .forEach { token in
                    guard let tokenAddress = token.address,
                          let symbol = token.symbol,
                          let tokenWalletType = WalletType(rawValue: cryptoType + symbol)
                    else {
                        return
                    }
                    let fiat = token.fiatPrice * ((token.balance as? NSString)?.doubleValue ?? 1)
                    let fiatAmount = String(format: "%.2f", fiat)

                    let tokenCard = WalletInfo(
                        decimals: Int(token.decimals),
                        walletType: tokenWalletType,
                        address: wallet.address ?? "",
                        tokenAddress: tokenAddress,
                        coinAmount: token.balance ?? "0",
                        fiatAmount: fiatAmount
                    )
                    cards.append(tokenCard)
                }
        }
        cards = cards.sorted()
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
        
        var aura = [WalletPublic]()
        if let publicKey: String = keychainService[.auraPublicKey] {
            aura.append(WalletPublic(publicKey: publicKey))
        }

        let params = AddressRequestParams(
            ethereum: ethereum,
            bitcoin: bitcoin,
            binance: binance,
            aura: aura
        )

        return params
    }

    static func makeAdressesData(wallets: [WalletNetwork]) -> [String: [String: String]] {
        let ethAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.ethereum.rawValue })?.address   // ETH, USDT, USDC
        let btcAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.bitcoin.rawValue })?.address    // BTC
        let bncAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.binance.rawValue })?.address    // BNB, USDT, USDC
        let aurAddress = wallets
            .first(where: { $0.cryptoType == CryptoType.aura.rawValue })?.address    // Aura

        let adressesData = AdressesData(
            eth: ethAddress,
            btc: btcAddress,
            bnc: bncAddress,
            aur: aurAddress
        ).getDataForPatchAssets()

        return adressesData
    }

    static func makeTransactions(
        networkTokens: [NetworkToken],
        model: WalletsTransactionsResponse
    ) -> TransactionSections {

        let walletSections: [TransactionSection] = [
            model.ethereum,
            model.bitcoin,
            model.binance,
            model.aura
        ].reduce(into: [TransactionSection](), { partialResult, sections in
            sections?.forEach { address, transactions in
                let transactionsBatch = makeTransactionSection(
                    address: address,
                    networkTokens: networkTokens,
                    cryptoTransactions: transactions
                )
                partialResult.append(contentsOf: transactionsBatch)
            }
        })

        let sections: [WalletType: [TransactionSection]] = walletSections
            .reduce(into: [WalletType: [TransactionSection]]()) { partialResult, transactionSection in
                var transactions = partialResult[transactionSection.walletType] ?? [TransactionSection]()
                transactions.append(transactionSection)
                partialResult[transactionSection.walletType] = transactions
            }
        return TransactionSections(sections: sections)
    }

    static func makeTransactionSection(
        address: String,
        networkTokens: [NetworkToken],
        cryptoTransactions: [CryptoTransaction]
    ) -> [TransactionSection] {

        let transactions: [TransactionSection] = cryptoTransactions
            .compactMap { transaction in
                let walletType: WalletType
                if let tokenAddress = transaction.tokenAddress,
                   let tokenSymbol = networkTokens
                    .first(where: { $0.address == tokenAddress })?.symbol,
                   let type = WalletType(rawValue: transaction.cryptoType + tokenSymbol) {
                    walletType = type
                } else if let type = WalletType(rawValue: transaction.cryptoType) {
                    walletType = type
                } else {
                    return nil
                }

                guard
                    let cryptoType = CryptoType(rawValue: transaction.cryptoType)
                else {
                    return nil
                }

                let info = TransactionInfo(
                    type: transaction.inputs.first?.address == address ? .send : .receive,
                    date: transaction.time ?? "",
                    transactionCoin: walletType,
                    transactionResult: transaction.status,
                    amount: transaction.inputs.first?.value ?? "",
                    from: transaction.inputs.first?.address ?? ""
                )
                let details = TransactionDetails(
                    sender: transaction.inputs.first?.address ?? "",
                    receiver: transaction.outputs.first?.address ?? "",
                    block: "\(transaction.block ?? 0)",
                    hash: transaction.hash
                )
                return TransactionSection(
                    address: address,
                    cryptoType: cryptoType,
                    walletType: walletType,
                    tokenAddress: transaction.tokenAddress,
                    info: info,
                    details: details
                )
            }
        return transactions
    }

    static func makeTransactionsRequestParams(
        wallets: [WalletAddress]
    ) -> TransactionsRequestParams {
        let transactions: [WalletTransactions] = wallets.compactMap {
            WalletTransactions(
                cryptoType: $0.cryptoType,
                address: $0.address,
                tokenAddress: $0.tokenAddress
            )
        }
        let params = TransactionsRequestParams(walletTransactions: transactions)
        return params
    }

    static func makeWalletsAddresses(
        wallets: [WalletNetwork],
        tokens: [NetworkToken]
    ) -> [WalletAddress] {

        let networkAddresses: [WalletAddress] = wallets
            .compactMap {
                guard
                    let address = $0.address,
                    let cryptoT = $0.cryptoType,
                    let cryptoType = CryptoType(rawValue: cryptoT)
                else {
                    return nil
                }
                return WalletAddress(
                    cryptoType: cryptoType,
                    address: address,
                    tokenAddress: nil
                )
            }
        let tokenAddresses: [WalletAddress] = networkAddresses
            .reduce(into: [WalletAddress](), { partialResult, networkAddress in

                let res: [WalletAddress] = tokens
                    .filter { $0.network == networkAddress.cryptoType.rawValue }
                    .compactMap {
                        guard
                            let tokenAddress = $0.address,
                            !tokenAddress.isEmpty,
                            let cryptoT = $0.network,
                            let cryptoType = CryptoType(rawValue: cryptoT)
                        else {
                            return nil
                        }
                        return WalletAddress(
                            cryptoType: cryptoType,
                            address: networkAddress.address,
                            tokenAddress: tokenAddress
                        )
                    }
                partialResult.append(contentsOf: res)
            })
        return networkAddresses + tokenAddresses
    }

    static func networkTokenResponseParse(response: NetworkTokensResponse) -> [NetworkTokenPonso] {

        var result = [NetworkTokenPonso]()

        [
            (key: CryptoType.binance, values: response.binance),
            (key: CryptoType.bitcoin, values: response.bitcoin),
            (key: CryptoType.ethereum, values: response.ethereum),
            (key: CryptoType.aura, values: response.aura)
        ]
            .forEach { obj in
                guard let tokens = obj.values else { return }
                let nTokens = tokens.map {
                    NetworkTokenPonso(networkTokenModel: $0, cryptoType: obj.key)
                }
                result.append(contentsOf: nTokens)
            }
        return result
    }
}
