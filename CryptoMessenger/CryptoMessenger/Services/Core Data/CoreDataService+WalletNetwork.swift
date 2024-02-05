import CoreData
import Foundation

private extension String {
    static let entityName = "WalletNetwork"

    static let id = "id"
    static let lastUpdate = "lastUpdate"
    static let cryptoType = "cryptoType"
    static let name = "name"
    static let derivePath = "derivePath"

    // Token
    static let address = "address"
    static let contractType = "contractType"
    static let decimals = "decimals"
    static let symbol = "symbol"

    // Other
    static let balance = "balance"
    static let fiatBalance = "fiatBalance"
}

// MARK: - WalletNetworkEntity

extension CoreDataService {

    // MARK: - GET

    func getNetworkWalletsTypes() -> [WalletType] {
        let networks: [WalletNetwork] = getWalletNetworks()
        return networks.compactMap { WalletType(rawValue: $0.cryptoType ?? "") }
    }

    func getWalletNetworks() -> [WalletNetwork] {
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch let err {
            debugPrint(err)
        }
        return []
    }

    func getWalletNetworksCount() -> Int {
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
        do {
            return try context.count(for: fetchRequest)
        } catch let err {
            debugPrint(err)
        }
        return .zero
    }

    func getWalletNetwork(byId id: UUID) -> WalletNetwork? {
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            return try context.fetch(fetchRequest).first
        } catch let err {
            debugPrint(err)
        }
        return nil
    }

    func requestNetworkWalletsTypes() async -> [WalletType] {
        let networks: [WalletNetwork] = await requestWalletNetworks()
        return networks.compactMap { WalletType(rawValue: $0.cryptoType ?? "") }
    }

    func requestWalletNetworks() async -> [WalletNetwork] {
        let context = privateQueueContext
        let tokens: [WalletNetwork] = await context.perform {
            let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
            return (try? context.fetch(fetchRequest)) ?? []
        }
        return tokens
    }

    func requestWalletNetworksCount() async -> Int {
        let context = privateQueueContext
        let count: Int = await context.perform {
            let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
            let wNetworksCount: Int = (try? context.count(for: fetchRequest)) ?? .zero
            return wNetworksCount
        }
        return count
    }

    func requestWalletNetwork(byId id: UUID) async -> [WalletNetwork] {
        let context = privateQueueContext
        let wNetworks: [WalletNetwork] = await context.perform {
            let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            return (try? context.fetch(fetchRequest)) ?? []
        }
        return wNetworks
    }

    // MARK: - CREATE

    @discardableResult
    func createWalletNetwork(wallet: WalletNetworkModel) -> WalletNetwork? {
        createWalletNetwork(
            id: UUID(),
            lastUpdate: wallet.lastUpdate,
            cryptoType: wallet.cryptoType,
            name: wallet.name,
            derivePath: wallet.derivePath,
            address: wallet.token.address,
            contractType: wallet.token.contractType,
            decimals: wallet.token.decimals,
            symbol: wallet.token.symbol,
            balance: nil,
            fiatBalance: nil
        )
    }

    @discardableResult
    func createWalletNetwork(
        id: UUID,
        lastUpdate: String,
        cryptoType: String,
        name: String,
        derivePath: String,
        // Token
        address: String,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        // Other
        balance: String?,
        fiatBalance: String?
    ) -> WalletNetwork? {

        let context = privateQueueContext
        let model = NSEntityDescription.insertNewObject(
            forEntityName: .entityName,
            into: context
        )
        model.setValue(id, forKey: .id)
        model.setValue(name, forKey: .name)
        model.setValue(lastUpdate, forKey: .lastUpdate)
        model.setValue(cryptoType, forKey: .cryptoType)
        model.setValue(derivePath, forKey: .derivePath)
        // Token
        model.setValue(address, forKey: .address)
        model.setValue(contractType, forKey: .contractType)
        model.setValue(decimals, forKey: .decimals)
        model.setValue(symbol, forKey: .symbol)

        // Other
        model.setValue(balance, forKey: .balance)
//        model.setValue(fiatBalance, forKey: .fiatBalance)

        do {
            try context.save()
        } catch let err {
            debugPrint(err)
        }
        return model as? WalletNetwork
    }

    @discardableResult
    func makeWalletNetwork(wallet: WalletNetworkModel) async -> WalletNetwork? {
        await makeWalletNetwork(
            id: UUID(),
            lastUpdate: wallet.lastUpdate,
            cryptoType: wallet.cryptoType,
            name: wallet.name,
            derivePath: wallet.derivePath,
            address: wallet.token.address,
            contractType: wallet.token.contractType,
            decimals: wallet.token.decimals,
            symbol: wallet.token.symbol,
            balance: nil,
            fiatBalance: nil
        )
    }

    @discardableResult
    func makeWalletNetwork(
        id: UUID,
        lastUpdate: String,
        cryptoType: String,
        name: String,
        derivePath: String,
        // Token
        address: String,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        // Other
        balance: String?,
        fiatBalance: String?
    ) async -> WalletNetwork? {
        let context = privateQueueContext
        let wnModel: WalletNetwork? = await context.perform {
            let model = NSEntityDescription.insertNewObject(
                forEntityName: .entityName,
                into: context
            )
            model.setValue(id, forKey: .id)
            model.setValue(name, forKey: .name)
            model.setValue(lastUpdate, forKey: .lastUpdate)
            model.setValue(cryptoType, forKey: .cryptoType)
            model.setValue(derivePath, forKey: .derivePath)
            // Token
            model.setValue(address, forKey: .address)
            model.setValue(contractType, forKey: .contractType)
            model.setValue(decimals, forKey: .decimals)
            model.setValue(symbol, forKey: .symbol)
            // Other
            model.setValue(balance, forKey: .balance)
//            model.setValue(fiatBalance, forKey: .fiatBalance)
            try? context.save()
            return model as? WalletNetwork
        }
        return wnModel
    }

    // MARK: - UPDATE

    @discardableResult
    func updateWalletNetwork(model: WalletNetwork) -> WalletNetwork? {
        updateWalletNetwork(
            id: model.id ?? UUID(),
            lastUpdate: model.lastUpdate ?? "",
            cryptoType: model.cryptoType ?? "",
            name: model.name ?? "",
            derivePath: model.derivePath ?? "",
            // Token
            address: model.address ?? "",
            contractType: model.contractType,
            decimals: model.decimals,
            symbol: model.symbol ?? "",
            // Other
            balance: model.balance,
            fiatBalance: "" // model.fiatBalance?.stringValue
        )
    }

    @discardableResult
    func updateWalletNetwork(
        id: UUID,
        lastUpdate: String,
        cryptoType: String,
        name: String,
        derivePath: String,
        // Token
        address: String,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        // Other
        balance: String?,
        fiatBalance: String?
    ) -> WalletNetwork? {

        guard let model = getWalletNetwork(byId: id) else { return nil }

        let context = privateQueueContext
        model.setValue(name, forKey: .name)
        model.setValue(lastUpdate, forKey: .lastUpdate)
        model.setValue(cryptoType, forKey: .cryptoType)
        model.setValue(derivePath, forKey: .derivePath)
        // Token
        model.setValue(address, forKey: .address)
        model.setValue(contractType, forKey: .contractType)
        model.setValue(decimals, forKey: .decimals)
        model.setValue(symbol, forKey: .symbol)
        // Other
        model.setValue(balance, forKey: .balance)
//        model.setValue(fiatBalance, forKey: .fiatBalance)

        do {
            try context.save()
        } catch let err {
            debugPrint(err)
        }
        return model as? WalletNetwork
    }

    @discardableResult
    func renewWalletNetwork(model: WalletNetwork) async -> WalletNetwork? {
        await renewWalletNetwork(
            id: model.id ?? UUID(),
            lastUpdate: model.lastUpdate ?? "",
            cryptoType: model.cryptoType ?? "",
            name: model.name ?? "",
            derivePath: model.derivePath ?? "",
            // Token
            address: model.address ?? "",
            contractType: model.contractType,
            decimals: model.decimals,
            symbol: model.symbol ?? "",
            // Other
            balance: model.balance,
            fiatBalance: "" // model.fiatBalance?.stringValue
        )
    }

    @discardableResult
    func renewWalletNetwork(
        id: UUID,
        lastUpdate: String,
        cryptoType: String,
        name: String,
        derivePath: String,
        // Token
        address: String,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        // Other
        balance: String?,
        fiatBalance: String?
    ) async -> WalletNetwork? {
        let context = privateQueueContext
        let wnModel: WalletNetwork? = await context.perform {
            let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let tokens: [WalletNetwork] = (try? context.fetch(fetchRequest)) ?? []

            guard let model: WalletNetwork = tokens.first else {
                return nil
            }
            model.setValue(name, forKey: .name)
            model.setValue(lastUpdate, forKey: .lastUpdate)
            model.setValue(cryptoType, forKey: .cryptoType)
            model.setValue(derivePath, forKey: .derivePath)
            // Token
            model.setValue(address, forKey: .address)
            model.setValue(contractType, forKey: .contractType)
            model.setValue(decimals, forKey: .decimals)
            model.setValue(symbol, forKey: .symbol)
            // Other
            model.setValue(balance, forKey: .balance)
//            model.setValue(fiatBalance, forKey: .fiatBalance)
            try? context.save()
            return model
        }
        return wnModel
    }

    // MARK: - DELETE

    func deleteWalletNetwork(byId id: UUID) {
        let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let context = privateQueueContext
            let result = try context.fetch(fetchRequest) as [WalletNetwork]
            result.forEach(context.delete)
            try context.save()
        } catch {
            debugPrint("Error deleting card with id: \(id)")
        }
    }

    func deleteAllWalletNetworks() {
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: .entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch let deletionError {
            debugPrint(deletionError)
        }
    }

    func removeWalletNetwork(byId id: UUID) async {
        let context = privateQueueContext
        await context.perform {
            let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let result: [WalletNetwork]? = try? context.fetch(fetchRequest)
            result?.forEach(context.delete)
            try? context.save()
        }
    }

    @discardableResult
    func removeAllWalletNetworks() async -> Bool {
        let context = privateQueueContext
        let result: Bool = await context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: .entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeStatusOnly
            let result = try? context.execute(batchDeleteRequest)
            try? context.save()
            let success = (result as? NSBatchDeleteResult)?.result as? Bool
            return success == true
        }
        return result
    }

    @discardableResult
    func deleteAllWalletNetworks() -> Bool {
        let context = mainQueueContext
        let result: Bool = context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: .entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeStatusOnly
            let result = try? context.execute(batchDeleteRequest)
            try? context.save()
            let success = (result as? NSBatchDeleteResult)?.result as? Bool
            return success == true
        }
        debugPrint("MATRIX DEBUG CoreDataService removeAllWalletNetworks \(result)")
        return result
    }
}
