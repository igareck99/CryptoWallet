import Foundation

protocol WalletRequestsFactoryProtocol {
	func buildNetworks(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildBalances(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildAddress(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactions(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildFee(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactionSend(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactionTemplate(parameters: BaseHTTPParameters) -> BaseEndPoint
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

	private var transactions: String {
		netType.rawValue + "/indexer/v0/transactions/address"
	}

	private var fee: String {
		netType.rawValue + "/indexer/v0/fee"
	}

	private var transactionSend: String {
		netType.rawValue + "/indexer/v0/transaction/send"
	}

	private var transactionTemplate: String {
		netType.rawValue + "/indexer/v0/transaction/template"
	}

	private let headers: BaseHTTPHeaders = ["Content-Type": "application/json"]

	let netType: NetType

	init(netType: NetType = .testnet) {
		self.netType = netType
	}

	// MARK: - WalletRequestsFactoryProtocol

	func buildNetworks(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: networks,
			httpMethod: .get,
			headers: headers,
			parameters: parameters
		)
	}

	func buildBalances(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: balances,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildAddress(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: address,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildTransactions(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: transactions,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildFee(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: fee,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildTransactionSend(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: transactionSend,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}

	func buildTransactionTemplate(parameters: BaseHTTPParameters) -> BaseEndPoint {
		BaseRequest(
			baseURL: baseUrl,
			path: transactionTemplate,
			httpMethod: .post,
			headers: headers,
			parameters: parameters
		)
	}
}
