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
	@NSManaged public var decimals: UInt
	@NSManaged public var symbol: String
}



/*
{
	"ethereum": {
		"lastUpdate": "2022-11-17T05:53:19Z",
		"cryptoType": "ethereum",
		"name": "Ethereum",
		"token": {
			"address": "",
			"contractType": null,
			"decimals": 18,
			"symbol": "ETH",
			"name": "Ethereum"
		},
		"derivePath": "m/44'/60'/0'/0/"
	},
	"bitcoin": {
		"lastUpdate": "2022-11-17T05:53:22Z",
		"cryptoType": "bitcoin",
		"name": "Bitcoin",
		"token": {
			"address": "",
			"contractType": null,
			"decimals": 8,
			"symbol": "BTC",
			"name": "Bitcoin"
		},
		"derivePath": "m/44'/1'/0'/0/"
	}
}
*/
