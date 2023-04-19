import CoreData
import Foundation

private extension String {
    static let entityName = "NetworkToken"
    static let id = "id"
    static let address = "address"
    static let contractType = "contractType"
    static let decimals = "decimals"
    static let symbol = "symbol"
    static let name = "name"
    static let network = "network"
}

// MARK: - NetworkTokenEntity

extension CoreDataService {

    // MARK: - GET
    
    func getNetworkTokensWalletsTypes() -> [WalletType] {
        getNetworksTokens()
            .compactMap {
                guard let cryptoType = $0.network,
                      let symbol = $0.symbol else {
                    return nil
                }
                return WalletType(rawValue: cryptoType + symbol)
            }
    }
    
    func getNetworksTokens() -> [NetworkToken] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch let err {
            debugPrint(err)
        }
        return []
    }

    func getNetworkToken(byId id: UUID) -> NetworkToken? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
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
    func createNetworkToken(
        token: NetworkTokenModel,
        network: String
    ) -> NetworkToken? {
        createNetworkToken(
            id: UUID(),
            address: token.address,
            contractType: token.contractType,
            decimals: token.decimals,
            symbol: token.symbol,
            name: token.name,
            network: network
        )
    }

    func createNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) -> NetworkToken? {

        let context = persistentContainer.viewContext
        let model = NSEntityDescription.insertNewObject(
            forEntityName: .entityName,
            into: context
        )
        model.setValue(id, forKey: .id)
        model.setValue(name, forKey: .name)
        model.setValue(address, forKey: .address)
        model.setValue(contractType, forKey: .contractType)
        model.setValue(decimals, forKey: .decimals)
        model.setValue(symbol, forKey: .symbol)
        model.setValue(name, forKey: .name)
        model.setValue(decimals, forKey: .decimals)
        model.setValue(network, forKey: .network)

        do {
            try context.save()
        } catch let err {
            debugPrint(err)
        }
        return model as? NetworkToken
    }

    // MARK: - UPDATE

    @discardableResult
    func updateNetworkToken(token: NetworkToken) -> NetworkToken? {
        updateNetworkToken(
            id: token.id ?? UUID(),
            address: token.address ?? "",
            contractType: token.contractType ?? "",
            decimals: token.decimals,
            symbol: token.symbol ?? "",
            name: token.name ?? "",
            network: token.network ?? ""
        )
    }

    @discardableResult
    func updateNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) -> NetworkToken? {

        guard let model = getNetworkToken(byId: id) else { return nil }

        let context = persistentContainer.viewContext
        model.setValue(address, forKey: .address)
        model.setValue(contractType, forKey: .contractType)
        model.setValue(decimals, forKey: .decimals)
        model.setValue(symbol, forKey: .symbol)
        model.setValue(name, forKey: .name)
        model.setValue(network, forKey: .network)

        do {
            try context.save()
        } catch let err {
            debugPrint(err)
        }
        return model
    }

    // MARK: - DELETE

    func deleteNetworkToken(byId id: UUID) {
        let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let context = persistentContainer.viewContext
            let result = try context.fetch(fetchRequest) as [NetworkToken]
            result.forEach(context.delete)
            try context.save()
        } catch {
            debugPrint("Error deleting card with id: \(id)")
        }
    }

    func deleteAllNetworksTokens() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: .entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch let deletionError {
            debugPrint(deletionError)
        }
    }
}
