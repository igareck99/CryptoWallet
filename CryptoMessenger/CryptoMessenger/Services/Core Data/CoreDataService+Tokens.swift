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
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch let err {
            debugPrint(err)
        }
        return []
    }

    func getNetworkToken(byId id: UUID) -> [NetworkToken] {
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let tokens = try? context.fetch(fetchRequest) else {
            return []
        }
        return tokens
    }

    func requestNetworkTokensWalletsTypes() async -> [WalletType] {
        await requestNetworksTokens()
            .compactMap {
                guard let cryptoType = $0.network,
                      let symbol = $0.symbol else {
                    return nil
                }
                return WalletType(rawValue: cryptoType + symbol)
            }
    }

    func requestNetworksTokens() async -> [NetworkToken] {
        let context = privateQueueContext
        let tokens: [NetworkToken] = await context.perform {
            let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
            return (try? context.fetch(fetchRequest)) ?? []
        }
        return tokens
    }

    func requestNetworkToken(byId id: UUID) async -> [NetworkToken] {
        let context = privateQueueContext
        let tokens: [NetworkToken] = await context.perform {
            let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            return (try? context.fetch(fetchRequest)) ?? []
        }
        return tokens
    }

    // MARK: - CREATE

    @discardableResult
    func makeNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) async -> NetworkToken? {
        let context = privateQueueContext
        let ntModel: NetworkToken? = await context.perform {
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
            try? context.save()
            return model as? NetworkToken
        }
        return ntModel
    }

    @discardableResult
    func makeNetworkToken(
        token: NetworkTokenModel,
        network: String
    ) async -> NetworkToken? {
        await makeNetworkToken(
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

        let context = privateQueueContext
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
        guard let model = getNetworkToken(byId: id).first else { return nil }

        let context = privateQueueContext
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

    @discardableResult
    func renewNetworkToken(token: NetworkToken) async -> NetworkToken? {
        await renewNetworkToken(
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
    func renewNetworkToken(
        id: UUID,
        address: String?,
        contractType: String?,
        decimals: Int16,
        symbol: String,
        name: String,
        network: String
    ) async -> NetworkToken? {
        let context = privateQueueContext
        let ntModel: NetworkToken? = await context.perform {
            let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let tokens: [NetworkToken] = (try? context.fetch(fetchRequest)) ?? []

            guard let model: NetworkToken = tokens.first else {
                return nil
            }
            model.setValue(address, forKey: .address)
            model.setValue(contractType, forKey: .contractType)
            model.setValue(decimals, forKey: .decimals)
            model.setValue(symbol, forKey: .symbol)
            model.setValue(name, forKey: .name)
            model.setValue(network, forKey: .network)
            try? context.save()
            return model
        }
        return ntModel
    }

    // MARK: - DELETE

    func deleteNetworkToken(byId id: UUID) {
        let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let context = privateQueueContext
            let result = try context.fetch(fetchRequest) as [NetworkToken]
            result.forEach(context.delete)
            try context.save()
        } catch {
            debugPrint("Error deleting card with id: \(id)")
        }
    }

    func deleteAllNetworksTokens() {
        let context = privateQueueContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: .entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch let deletionError {
            debugPrint(deletionError)
        }
    }

    func removeNetworkToken(byId id: UUID) async {
        let context = privateQueueContext
        await context.perform {
            let fetchRequest = NSFetchRequest<NetworkToken>(entityName: .entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let result: [NetworkToken]? = try? context.fetch(fetchRequest)
            result?.forEach(context.delete)
            try? context.save()
        }
    }

    @discardableResult
    func removeAllNetworksTokens() async -> Bool {
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
    func removeAllNetworksTokens() -> Bool {
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
        debugPrint("MATRIX DEBUG CoreDataService removeAllNetworksTokens \(result)")
        return result
    }
}
