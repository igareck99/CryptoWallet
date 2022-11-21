import CoreData

protocol CoreDataServiceProtocol {

	var persistentContainer: NSPersistentContainer { get }

	// MARK: - GET

	func getWalletNetworks() -> [WalletNetwork]

	func getWalletNetwork(byId id: UUID) -> WalletNetwork?

	// MARK: - CREATE

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
		balance: String?
	) -> WalletNetwork?

	@discardableResult
	func createWalletNetwork(wallet: WalletNetworkModel) -> WalletNetwork?

	// MARK: - UPDATE

	func updaterForWalletNetworks(fetchResultClosure: @escaping FetchResultClosure)

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
		balance: String?
	) -> WalletNetwork?

	@discardableResult
	func updateWalletNetwork(model: WalletNetwork) -> WalletNetwork?

	// MARK: - DELETE

	func deleteWalletNetwork(byId id: UUID)

	func deleteAllWalletNetworks()
}

private extension String {
	static let containerName = "wallets_networks"
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
}

typealias FetchResultClosure = ([WalletNetwork]) -> Void

final class CoreDataService: NSObject {

	static let shared: CoreDataServiceProtocol = CoreDataService()

	private var subscriptions = [NSFetchedResultsController<WalletNetwork>: FetchResultClosure]()

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: .containerName)
		container.loadPersistentStores { storeDescription, err in

			debugPrint("storeDescription: \(storeDescription)")

			if let error = err {
				fatalError("Load Failed: \(String(describing: err))")
			}
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		return container
	}()

	override init() {
		super.init()
		subscribeToNotifications()
	}

	private func subscribeToNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didUpdateModel),
			name: NSManagedObjectContext.didSaveObjectsNotification,
			object: nil
		)
	}

	@objc
	func didUpdateModel() {
		try? subscriptions.first?.key.performFetch()
		guard let result = subscriptions.first?.key.fetchedObjects else { return }
		subscriptions.forEach {
			$0.value(result)
		}
	}
}

// MARK: - CoreDataServiceProtocol

extension CoreDataService: CoreDataServiceProtocol {

	// MARK: - GET

	func getWalletNetworks() -> [WalletNetwork] {
		let context = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: .id, ascending: true)]
		do {
			return try context.fetch(fetchRequest)
		} catch let err {
			debugPrint(err)
		}
		return []
	}

	func getWalletNetwork(byId id: UUID) -> WalletNetwork? {
		let context = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<WalletNetwork>(entityName: .entityName)
		fetchRequest.predicate = NSPredicate(
			format: "id == %@",
			id.uuidString as CVarArg
		)

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
			balance: nil
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
		balance: String?
	) -> WalletNetwork? {

		let context = persistentContainer.viewContext
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
			id: model.id,
			lastUpdate: model.lastUpdate,
			cryptoType: model.cryptoType,
			name: model.name,
			derivePath: model.derivePath,
			// Token
			address: model.address,
			contractType: model.contractType,
			decimals: model.decimals,
			symbol: model.symbol,
			// Other
			balance: model.balance
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
		balance: String?
	) -> WalletNetwork? {

		guard let model = getWalletNetwork(byId: id) else { return nil }

		let context = persistentContainer.viewContext
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
		fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString as CVarArg)
		do {
			let context = persistentContainer.viewContext
			let result = try context.fetch(fetchRequest) as [WalletNetwork]
			result.forEach(context.delete)
			try context.save()
		} catch {
			debugPrint("Error deleting card with id: \(id)")
		}
	}

	func deleteAllWalletNetworks() {
		let context = persistentContainer.viewContext
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

// MARK: - NSFetchedResultsControllerDelegate

extension CoreDataService: NSFetchedResultsControllerDelegate {

	func controllerDidChangeContent(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>
	) {
		guard let fetchedController = controller as? NSFetchedResultsController<WalletNetwork>,
			  let fetchResultClosure = subscriptions[fetchedController],
			  let fetchedObjects = fetchedController.fetchedObjects else { return }
		fetchResultClosure(fetchedObjects)
	}
}
