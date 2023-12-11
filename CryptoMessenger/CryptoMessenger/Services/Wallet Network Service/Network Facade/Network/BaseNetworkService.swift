import Foundation

typealias BaseNetworkRequestCompletion = (Data?, URLResponse?, Error?) -> Void

struct BaseAsyncNetworkResponse {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

protocol BaseNetworkServiceProtocol: AnyObject {
	@discardableResult
	func send(
		request: URLRequest,
		completion: @escaping BaseNetworkRequestCompletion
	) -> URLSessionTask

    func send(request: URLRequest) async -> BaseAsyncNetworkResponse
}

final class NetworkService: BaseNetworkServiceProtocol {

	static let shared = NetworkService()

	private let session = URLSession.shared

	@discardableResult
	func send(
		request: URLRequest,
		completion: @escaping BaseNetworkRequestCompletion
	) -> URLSessionTask {
		let task = session.dataTask(with: request) { completion($0, $1, $2) }
		task.resume()
		return task
	}

    func send(request: URLRequest) async -> BaseAsyncNetworkResponse {
        do {
            let result = try await session.data(for: request)
            return .init(data: result.0, response: result.1, error: nil)
        } catch {
            return .init(data: nil, response: nil, error: error)
        }
    }
}
