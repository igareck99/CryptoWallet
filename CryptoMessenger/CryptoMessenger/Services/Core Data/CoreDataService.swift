import CoreData
// swiftlint:disable all

private extension String {
    static let containerName = "wallets_networks"
}

typealias FetchResultClosure = ([WalletNetwork]) -> Void

final class CoreDataService: NSObject, CoreDataServiceProtocol {

	static let shared: CoreDataServiceProtocol = CoreDataService()

	var subscriptions = [NSFetchedResultsController<WalletNetwork>: FetchResultClosure]()
    
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: .containerName)
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        
		container.loadPersistentStores { storeDescription, err in
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = false

			if let error = err {
				fatalError("Load Failed: \(String(describing: err))")
			}
		}
		return container
	}()
    
    let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let privateQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

	override init() {
		super.init()
		subscribeToNotifications()
        configureContexts()
	}
    
    private func configureContexts() {
        mainQueueContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        privateQueueContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
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

// MARK: - Private Queue Context

extension CoreDataService {
    
    /// Creates and configures a private queue context.
    func newTaskContext(
        name: String = .empty,
        author: String = .empty
    ) -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        // Add name and author to identify source of persistent history changes.
        taskContext.name = name
        taskContext.transactionAuthor = author
        return taskContext
    }
}
