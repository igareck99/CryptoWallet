import CoreData

@objc(WalletNetwork)
public class WalletNetwork: NSManagedObject {
	@NSManaged public var id: UUID
	@NSManaged public var lastUpdate: String
	@NSManaged public var cryptoType: String
	@NSManaged public var name: String
	@NSManaged public var derivePath: String
	// Token
	@NSManaged public var address: String
	@NSManaged public var contractType: String?
	@NSManaged public var decimals: Int16
	@NSManaged public var symbol: String

	// Other
	@NSManaged public var balance: String?
}
