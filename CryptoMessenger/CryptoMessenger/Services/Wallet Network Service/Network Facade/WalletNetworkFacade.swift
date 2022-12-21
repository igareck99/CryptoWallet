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
		params: FeeRequestParams,
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
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("getNetworks", data, response, error)
			guard
				let data = data,
				let model = Parser.parse(data: data, to: WalletNetworkResponse.self)
			else {
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success([model.ethereum, model.bitcoin]))
		}
	}

	// MARK: - Address

	func getAddress(
		params: AddressRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
	) {
		let paramsDict: [String: Any] = params.dictionary
		let request = walletRequestsFactory.buildAddress(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("getAddress", data, response, error)
			guard
				let data = data,
				let model = Parser.parse(data: data, to: AddressResponse.self)
			else {
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	// MARK: - Balances

	func getBalances(
		params: BalanceRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
	) {
		let paramsDict: [String: Any] = params.dictionary
		let request = walletRequestsFactory.buildBalances(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("getBalances", data, response, error)
			guard
				let data = data,
				let model = Parser.parse(data: data, to: BalancesResponse.self)
			else {
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	// MARK: - Transactions

	func getTransactions(
		params: TransactionsRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<WalletsTransactionsResponse>>
	) {
		let paramsDict: [String: Any] = params.dictionary
		let request = walletRequestsFactory.buildTransactions(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("getTransactions", data, response, error)
			guard
				let data = data,
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
		params: FeeRequestParams,
		completion: @escaping GenericBlock<EmptyFailureResult<FeeResponse>>
	) {
		let paramsDict: [String: Any] = params.dictionary
		let request = walletRequestsFactory.buildFee(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("getFee", data, response, error)
			guard
				let data = data,
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
		let paramsDict: [String: Any] = params.dictionary
		let request = walletRequestsFactory.buildTransactionTemplate(parameters: paramsDict)
		let urlRequest = networkRequestFactory.makePostRequest(from: request)
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("makeTransactionTemplate", data, response, error)
			guard
				let data = data,
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
		networkService.send(request: urlRequest) { [weak self] data, response, error in
			guard let self = self else { return }
			self.logReponse("makeTransactionSend", data, response, error)
			guard let data = data,
				  let model = Parser.parse(data: data, to: TransactionSendResponse.self)
			else {
				self.parseErrorMessage(data: data)
				completion(.failure)
				return
			}
			debugPrint("model: \(model)")
			completion(.success(model))
		}
	}

	@discardableResult
	private func parseErrorMessage(data: Data?) -> WalletErrorResponse? {
		guard
			let data = data,
			let model = Parser.parse(data: data, to: WalletErrorResponse.self)
		else {
			return nil
		}
		debugPrint("parseErrorMessage")
		debugPrint("Error model: \(model)")
		return model
	}

	private func logReponse(
		_ function: String,
		_ data: Data?,
		_ response: URLResponse?,
		_ error: Error?
	) {
		debugPrint("makeTransaction")
		debugPrint("data: \(String(describing: data))")
		debugPrint("response: \(String(describing: response))")
		debugPrint("error: \(String(describing: error))")
	}
}
