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

	func getFee(
		feeParams: FeeRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<FeeResponse>>
	)

	func makeTransactionTemplate(
		params: TransactionTemplateRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<TransactionTemplateResponse>>
	)

	func makeTransactionSend(
		params: TransactionSendRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<TransactionSendResponse>>
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
		let paramsDict: [String: Any] = [
			"ethereum": [["publicKey": params.ethereumPublicKey]],
			"bitcoin": [["publicKey": params.bitcoinPublicKey]]
		]
		let request = walletRequestsFactory.buildAddress(parameters: paramsDict)
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
		let paramsDict: [String: Any] = [
			"ethereum": [["accountAddress": params.ethereumAddress]],
			"bitcoin": [["accountAddress": params.bitcoinAddress]]
		]
		let request = walletRequestsFactory.buildBalances(parameters: paramsDict)
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
		let paramsDict: [String: Any] = [
			"ethereum": [[
				"address": params.ethereumAddress,
				"limit": "10"
			]],
			"bitcoin": [[
				"address": params.bitcoinAddress,
				"limit": "10"
			]]
		]
		let request = walletRequestsFactory.buildTransactions(parameters: paramsDict)
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

	// MARK: - Fee

	func getFee(
		feeParams: FeeRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<FeeResponse>>
	) {
		let paramsDict: [String: Any] = ["cryptoType": feeParams.cryptoType]
		let request = walletRequestsFactory.buildFee(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("getFee")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: FeeResponse.self)
			else {
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	// MARK: - Transaction template

	func makeTransactionTemplate(
		params: TransactionTemplateRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<TransactionTemplateResponse>>
	) {
		let paramsDict: [String: Any] = [
			"publicKey": params.publicKey,
			"addressTo": params.addressTo,
			"amount": params.amount,
			"fee": params.fee,
			"cryptoType": params.cryptoType
		]
		let request = walletRequestsFactory.buildTransactionTemplate(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("makeTransactionTemplate")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: TransactionTemplateResponse.self)
			else {
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	// MARK: - Transaction Send

	func makeTransactionSend(
		params: TransactionSendRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<TransactionSendResponse>>
	) {
		let paramsDict: [String: Any] = params.dictionary
		let request = walletRequestsFactory.buildTransactionSend(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { data, response, error in
			debugPrint("makeTransaction")
			debugPrint("data: \(String(describing: data))")
			debugPrint("response: \(String(describing: response))")
			debugPrint("error: \(String(describing: error))")
			guard let data = data,
				  let model = Parser.parse(data: data, to: TransactionSendResponse.self)
			else {
//				{
//				"message":
//				"Transaction with uuid 95fe50a7-c477-40e1-911e-0365704a2d4f not found"
//			}
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}
}
