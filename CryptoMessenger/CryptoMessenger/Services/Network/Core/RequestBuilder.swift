import Foundation

// MARK: - RequestBuilder

final class RequestBuilder {

    // MARK: - Types

    typealias Headers = [String: String]
    typealias QueryParams = [String: Any]

    // MARK: - Method

    enum Method: String {

        // MARK: - Types

        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    // MARK: - RequestType

    enum RequestType {

        // MARK: - Types

        case request
        case upload
        case reward
    }

    // MARK: - Encoding

    enum Encoding {

        // MARK: - Types

        case formUrlEncoded, jsonEncoded
        case multipart(String)

        // MARK: - Internal Properties

        var type: String {
            switch self {
            case .formUrlEncoded:
                return "application/x-www-form-urlencoded"
            case .jsonEncoded:
                return "application/json"
            case .multipart(let boundary):
                return "multipart/form-data; boundary=\(boundary)"
            }
        }
    }

    // MARK: - Internal Properties

    private(set) var baseURL: String?
    private(set) var headers: Headers?
    private(set) var queryParameters: QueryParams?

    // MARK: - Private Properties

    private let configuration: ConfigType
    private let method: Method
    private let requestType: RequestType
    private let path: String
    private var body: Data?

    // MARK: - Internal Properties

    var description: String { "\(method.rawValue) \(path)" }
    var debugDescription: String {
        let payload = body.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        return "\(description) \n \(payload)"
    }

    // MARK: - Lifecycle

    init(
        method: Method,
        path: String,
        requestType: RequestType,
        configuration: ConfigType = Configuration()
    ) {
        self.method = method
        self.requestType = requestType
        self.configuration = configuration

        let apiVersion = "/" + configuration.apiVersionString
        if let components = URLComponents(string: apiVersion + path), let params = components.queryItems {
            self.path = components.path
            self.queryParameters = QueryParams(uniqueKeysWithValues: params.map({ ($0.name, $0.value) }))
        } else {
            if requestType != .reward {
                self.path = apiVersion + path
                return
            }
            self.path = path
        }
    }

    // MARK: - Internal Methods

    func body(_ body: Data) -> RequestBuilder {
        self.body = body
        return self
    }

    func jsonBody<T: Encodable>(_ payload: T) -> RequestBuilder {
        let data = try? JSONEncoder().encode(payload)
        self.body = data
        return addHeader("Content-Type", value: Encoding.jsonEncoded.type)
    }

    func jsonBody(dict: [String: Any]) -> RequestBuilder {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        self.body = data
        return addHeader("Content-Type", value: Encoding.jsonEncoded.type)
    }

    func jsonBody(array: [String]) -> RequestBuilder {
        let data = try? JSONSerialization.data(withJSONObject: array, options: [])
        self.body = data
        return addHeader("Content-Type", value: Encoding.jsonEncoded.type)
    }

    func formUrlBody(_ params: [String: String], encoding: Encoding) -> RequestBuilder {
        let formUrlData: String? = params.map { k, v in
            let escapedKey = k.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? k
            let escapedValue = v.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? v
            return "\(escapedKey)=\(escapedValue)"
        }.joined(separator: "&")

        body = formUrlData?.data(using: .utf8)

        return addHeader("Content-Type", value: Encoding.formUrlEncoded.type)
    }

    func multipartBody(_ multipart: MultipartFileData) -> RequestBuilder {
        let httpBody = NSMutableData()

        for (key, value) in multipart.formFields {
            httpBody.appendString(convertFormField(name: key, value: value, using: multipart.boundary))
        }

        httpBody.append(convertFileData(multipart))
        httpBody.appendString("--\(multipart.boundary)--")

        self.body = httpBody as Data
        return addHeader("Content-Type", value: Encoding.multipart(multipart.boundary).type)
    }

    func convertFormField(name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    func convertFileData(_ multipart: MultipartFileData) -> Data {
        let content = "Content-Disposition: form-data; name=\"\(multipart.field)\"; filename=\"\(multipart.file)\"\r\n"

        let data = NSMutableData()
        data.appendString("--\(multipart.boundary)\r\n")
        data.appendString(content)
        data.appendString("Content-Type: \(multipart.mimeType)\r\n\r\n")
        data.append(multipart.fileData)
        data.appendString("\r\n")

        return data as Data
    }

    func addHeader(_ header: String, value: String) -> RequestBuilder {
        if headers == nil {
            headers = [:]
        }
        self.headers?[header] = value
        return self
    }

    func query(_ query: QueryParams) -> RequestBuilder {
        self.queryParameters = query
        return self
    }

    func query(_ queryItems: [URLQueryItem]?) -> RequestBuilder {
        guard let queryItems = queryItems else { return self }
        guard queryParameters != nil else {
            queryParameters = [:]
            return self
        }
        queryItems.forEach {
            queryParameters?[$0.name] = $0.value
        }
        return self
    }

    func addQuery(_ query: String, value: String) -> RequestBuilder {
        guard queryParameters != nil else {
            queryParameters = [:]
            return self
        }
        queryParameters?[query] = value
        return self
    }
}

// MARK: - RequestBuilder (URLRequestConvertible)

extension RequestBuilder: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: configuration.apiUrlString) else {
            fatalError("URLComponents failed")
        }
        urlComponents.path = path
        if let queryParams = queryParameters as? [String: String] {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = self.body
        return request
    }
}
