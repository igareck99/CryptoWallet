import Foundation

protocol WalletNetworkFacadeProtocol {
	func getNetworks(
		completion: @escaping GenericBlock<EmptyFailureResult<[WalletNetworkModel]>>
	)

	func getAddress(
		params: AddressRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
	)

	func getBalances(
		params: BalanceRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
	)

	func getTransactions(
		params: TransactionsRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<WalletsTransactionsResponse>>
	)
}

final class WalletNetworkFacade {

	private let walletRequestsFactory: WalletRequestsFactoryProtocol
	private let networkService: BaseNetworkServiceProtocol
	private let networkRequestFactory: BaseNetworkRequestFactoryProtocol

	init(
		walletRequestsFactory: WalletRequestsFactoryProtocol = WalletRequestsFactory(),
		networkRequestFactory: BaseNetworkRequestFactoryProtocol = BaseNetworkRequestFactory(),
		networkService: BaseNetworkServiceProtocol = NetworkService.shared
	) {
		self.walletRequestsFactory = walletRequestsFactory
		self.networkRequestFactory = networkRequestFactory
		self.networkService = networkService
	}
}

// MARK: - WalletNetworkFacadeProtocol

extension WalletNetworkFacade: WalletNetworkFacadeProtocol {

	// MARK: - Network Wallets

	func getNetworks(completion: @escaping GenericBlock<EmptyFailureResult<[WalletNetworkModel]>>) {
		let request = walletRequestsFactory.buildNetworks(parameters: [:])
		let urlRequest = networkRequestFactory.makeGetRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("getNetworks")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: WalletNetworkResponse.self)
			else { completion(.failure); return }
			debugPrint("model: \(model)")
			completion(.success([model.ethereum, model.bitcoin]))
		}
	}

	// MARK: - Address

	func getAddress(
		params: AddressRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
	) {
		let parameters: [String: Any] = [
			"ethereum": [["publicKey": params.ethereumPublicKey]],
			"bitcoin": [["publicKey": params.bitcoinPublicKey]]
		]
		let request = walletRequestsFactory.buildAddress(parameters: parameters)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("getAddress")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: AddressResponse.self)
			else { completion(.failure); return }
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	// MARK: - Balances

	func getBalances(
		params: BalanceRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
	) {
		let params: [String: Any] = [
			"ethereum": [["accountAddress": params.ethereumAddress]],
			"bitcoin": [["accountAddress": params.bitcoinAddress]]
		]
		let request = walletRequestsFactory.buildBalances(parameters: params)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("getBalances")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: BalancesResponse.self)
			else { completion(.failure); return }
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	// MARK: - Transactions

	func getTransactions(
		params: TransactionsRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<WalletsTransactionsResponse>>
	) {
		let params: [String: Any] = [
			"ethereum": [[
				"address": params.ethereumAddress,
				"limit": "10"
			]],
			"bitcoin": [[
				"address": params.bitcoinAddress,
				"limit": "10"
			]]
		]
		let request = walletRequestsFactory.buildTransactions(parameters: params)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("getTransactions")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: WalletsTransactionsResponse.self)
			else {
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}
}
