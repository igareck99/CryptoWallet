import CoreData
// swiftlint:disable all

private extension String {
    static let containerName = "wallets_networks"
}

typealias FetchResultClosure = ([WalletNetwork]) -> Void

final class CoreDataService: NSObject, CoreDataServiceProtocol {

	static let shared: CoreDataServiceProtocol = CoreDataService()

	var subscriptions = [NSFetchedResultsController<WalletNetwork>: FetchResultClosure]()
    
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: .containerName)
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        
		container.loadPersistentStores { storeDescription, err in

			debugPrint("storeDescription: \(storeDescription)")
            
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = false

			if let error = err {
				fatalError("Load Failed: \(String(describing: err))")
			}
		}
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
