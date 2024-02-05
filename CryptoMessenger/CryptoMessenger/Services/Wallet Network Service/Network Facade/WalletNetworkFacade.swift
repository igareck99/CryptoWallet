import Foundation

enum NetworkFacadeError: Error {
    case parseFailed
}

final class WalletNetworkFacade {

    let networkService: BaseNetworkServiceProtocol
    let walletRequestsFactory: WalletRequestsFactoryProtocol
    let networkRequestFactory: BaseNetworkRequestFactoryProtocol

	init(
		walletRequestsFactory: WalletRequestsFactoryProtocol = WalletRequestsFactory(),
		networkRequestFactory: BaseNetworkRequestFactoryProtocol = BaseNetworkRequestFactory(),
		networkService: BaseNetworkServiceProtocol = NetworkService.shared
	) {
		self.walletRequestsFactory = walletRequestsFactory
		self.networkRequestFactory = networkRequestFactory
		self.networkService = networkService
	}

	@discardableResult
    func parseErrorMessage(data: Data?) -> WalletErrorResponse? {
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

    func logReponse(
		_ function: String,
		_ data: Data?,
		_ response: URLResponse?,
		_ error: Error?
	) {
        debugPrint("function: \(function) \\n")
        debugPrint("data: \(String(data: data ?? Data(), encoding: .utf8) ?? "no data") \\n")
		debugPrint("response: \(String(describing: response)) \\n")
		debugPrint("error: \(String(describing: error)) \\n")
	}

    func send(
        request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        networkService.send(request: request) { [weak self] data, response, error in
            completion(data, response, error)
        }
    }
}
