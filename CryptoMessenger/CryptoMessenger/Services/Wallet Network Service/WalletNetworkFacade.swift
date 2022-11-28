import Foundation

protocol WalletNetworkFacadeProtocol {
	func getNetworks(
		completion: @escaping GenericBlock<EmptyFailureResult<[WalletNetworkModel]>>
	)

	func getAddress(
		parameters: [String: Any],
		completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
	)

	func getBalances(
		parameters: [String: Any],
		completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
	)
}

final class WalletNetworkFacade {

	private let walletRequestsFactory: WalletRequestsFactoryProtocol = WalletRequestsFactory()
	private let networkService: BaseNetworkServiceProtocol
	private let networkRequestFactory: BaseNetworkRequestFactoryProtocol

	init(
		walletRequestsFactory: WalletRequestsFactoryProtocol = WalletRequestsFactory(),
		networkRequestFactory: BaseNetworkRequestFactoryProtocol = BaseNetworkRequestFactory(),
		networkService: BaseNetworkServiceProtocol = NetworkService.shared
	) {
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
		parameters: [String: Any],
		completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
	) {
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
		parameters: [String: Any],
		completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
	) {
		let request = walletRequestsFactory.buildBalances(parameters: parameters)
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
}
