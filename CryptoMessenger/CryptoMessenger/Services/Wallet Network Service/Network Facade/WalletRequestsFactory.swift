import Foundation

protocol WalletRequestsFactoryProtocol {
    func buildTokens(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildNetworks(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildBalances(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildAddress(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactions(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildFee(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactionSend(parameters: BaseHTTPParameters) -> BaseEndPoint

	func buildTransactionTemplate(parameters: BaseHTTPParameters) -> BaseEndPoint
}

struct WalletRequestsFactory: WalletRequestsFactoryProtocol {

    private let config: ConfigType = Configuration.shared
    private var baseUrl: URL {
        config.cryptoWallet.asURL()
    }

    private var tokens: String {
        genericPart + "/tokens"
    }

	private var networks: String {
        genericPart + "/networks"
	}

	private var address: String {
        genericPart + "/address"
	}

	private var balances: String {
        genericPart + "/balances"
	}

	private var transactions: String {
        genericPart + "/transactions/address"
	}

	private var fee: String {
        genericPart + "/fee"
	}

	private var transactionSend: String {
        genericPart + "/transaction/send"
	}

	private var transactionTemplate: String {
        genericPart + "/transaction/template"
	}
    private var genericPart: String {
        apiVersion.rawValue + "/indexer/" + netType.rawValue
    }

	private let headers: BaseHTTPHeaders = ["Content-Type": "application/json"]

	let netType: NetType
    let apiVersion: ApiVersion

    init(
        netType: NetType = Configuration.shared.netType,
        apiVersion: ApiVersion = .v0
    ) {
		self.netType = netType
        self.apiVersion = apiVersion
	}

	// MARK: - WalletRequestsFactoryProtocol

    func buildTokens(parameters: BaseHTTPParameters) -> BaseEndPoint {
        BaseRequest(
            baseURL: baseUrl,
            path: tokens,
            httpMethod: .post,
            headers: headers,
            parameters: parameters
        )
    }

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
