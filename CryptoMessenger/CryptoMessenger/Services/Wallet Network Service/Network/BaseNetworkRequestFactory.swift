import Foundation

protocol BaseNetworkRequestFactoryProtocol {
	func makeGetRequest(from model: BaseEndPoint) -> URLRequest
	func makePostRequest(from model: BaseEndPoint) -> URLRequest
	func makePostParamsRequest(from model: BaseEndPoint) -> URLRequest
}

struct BaseNetworkRequestFactory: BaseNetworkRequestFactoryProtocol {

	func makeGetRequest(from model: BaseEndPoint) -> URLRequest {
		let params: String = model.parameters
			.lazy
			.map { $0 + "=" + "\($1)" }
			.joined(separator: "&")

		let urlStr = model.baseURL.absoluteString + model.path + "?" + params
		guard let url = URL(string: urlStr) else { fatalError("URL could not be created!!!") }
		var request = URLRequest(url: url)
		request.httpMethod = model.httpMethod.rawValue
		model.headers.forEach {
			request.addValue($1, forHTTPHeaderField: $0)
		}
		return request
	}

	func makePostRequest(from model: BaseEndPoint) -> URLRequest {
		let urlStr = model.baseURL.absoluteString + model.path
		guard let url = URL(string: urlStr) else { fatalError("URL could not be created!!!") }
		var request = URLRequest(url: url)
		request.httpBody = try? JSONSerialization.data(withJSONObject: model.parameters)
		request.httpMethod = model.httpMethod.rawValue
		model.headers.forEach {
			request.addValue($1, forHTTPHeaderField: $0)
		}
		return request
	}

	func makePostParamsRequest(from model: BaseEndPoint) -> URLRequest {
		let params: String = model.parameters
			.lazy
			.map { $0 + "=" + "\($1)" }
			.joined(separator: "&")

		let urlStr = model.baseURL.absoluteString + model.path + "?" + params
		guard let url = URL(string: urlStr) else { fatalError("URL could not be created!!!") }
		var request = URLRequest(url: url)
		request.httpBody = try? JSONSerialization.data(withJSONObject: model.parameters)
		request.httpMethod = model.httpMethod.rawValue
		model.headers.forEach {
			request.addValue($1, forHTTPHeaderField: $0)
		}
		return request
	}
}
