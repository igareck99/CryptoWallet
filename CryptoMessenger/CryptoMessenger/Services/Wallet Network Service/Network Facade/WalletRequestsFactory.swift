import Foundation

protocol WalletRequestsFactoryProtocol {
	func buildNetworks(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildBalances(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildAddress(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactions(parameters: BaseHTTPParameters) -> BaseEndPoint
}

struct WalletRequestsFactory: WalletRequestsFactoryProtocol {

	private let baseUrl = URL(string: "https://crypto.auramsg.co/")!

	enum NetType: String {
		case mainnet
		case testnet
	}

	private var networks: String {
		netType.rawValue + "/indexer/v0/networks"
	}

	private var address: String {
		netType.rawValue + "/indexer/v0/address"
	}

	private var balances: String {
		netType.rawValue + "/indexer/v0/balances"
	}

	private var tranactions: String {
		netType.rawValue + "/indexer/v0/transactions/address"
	}

	private let headers: BaseHTTPHeaders = ["Content-Type": "application/json"]

	let netType: NetType

	init(netType: NetType = .testnet) {
		self.netType = netType
	}

	// MARK: - WalletRequestsFactoryProtocol

	func buildNetworks(parameters: BaseHTTPParameters) -> BaseEndPoint {
		return BaseRequest(
			baseURL: baseUrl,
			path: networks,
			httpMethod: .get,
			headers: headers,
			parameters: parameters
		)
	}

	func buildBalances(parameters: BaseHTTPParameters) -> BaseEndPoint {
		return BaseRequest(
			baseURL: baseUrl,
			path: balances,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildAddress(parameters: BaseHTTPParameters) -> BaseEndPoint {
		return BaseRequest(
			baseURL: baseUrl,
			path: address,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildTransactions(parameters: BaseHTTPParameters) -> BaseEndPoint {
		return BaseRequest(
			baseURL: baseUrl,
			path: tranactions,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}
}
