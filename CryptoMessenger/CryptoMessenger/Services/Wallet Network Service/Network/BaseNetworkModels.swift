import Foundation

typealias BaseHTTPHeaders = [String: String]
typealias BaseHTTPParameters = [String: Any]

protocol BaseEndPoint {
	var baseURL: URL { get }
	var path: String { get }
	var httpMethod: BaseHTTPMethod { get }
	var headers: BaseHTTPHeaders { get }
	var parameters: BaseHTTPParameters { get }
}

enum BaseHTTPMethod: String {
	case get     = "GET"
	case post    = "POST"
	case put     = "PUT"
	case patch   = "PATCH"
	case delete  = "DELETE"
}

struct BaseRequest: BaseEndPoint {
	let baseURL: URL
	let path: String
	let httpMethod: BaseHTTPMethod
	let headers: BaseHTTPHeaders
	let parameters: BaseHTTPParameters
}
