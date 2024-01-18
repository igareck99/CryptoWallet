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
        getWalletNetworks()
            .compactMap { WalletType(rawValue: $0.cryptoType ?? "") }
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
        return model
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

    // MARK: - Updaters

    func updaterForWalletNetworks(fetchResultClosure: @escaping FetchResultClosure) {
        let request = NSFetchRequest<WalletNetwork>(entityName: .entityName)
        let sort = NSSortDescriptor(key: .name, ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 200

        let controller = NSFetchedResultsController<WalletNetwork>(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        subscriptions[controller] = fetchResultClosure

        do {
            try controller.performFetch()
        } catch {
            debugPrint("Fetch failed \(error)")
        }
    }
}
