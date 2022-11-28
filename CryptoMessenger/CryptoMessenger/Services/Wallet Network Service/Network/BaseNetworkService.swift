import Foundation

typealias BaseNetworkRequestCompletion = (Data?, URLResponse?, Error?) -> Void

protocol BaseNetworkServiceProtocol: AnyObject {
	@discardableResult
	func send(
		request: URLRequest,
		completion: @escaping BaseNetworkRequestCompletion
	) -> URLSessionTask
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
}
