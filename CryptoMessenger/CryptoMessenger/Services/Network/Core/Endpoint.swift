import Foundation

// MARK: - Endpoint

final class Endpoint<Response> {

    // MARK: - Private Properties

    private let decode: (Data) throws -> Response
    private var builder: RequestBuilder

    // MARK: - Internal Properties

    var debugDescription: String { "\(builder.debugDescription) expecting: \(Response.self)" }
    var description: String { "\(builder.description) expecting: \(Response.self)" }

    // MARK: - Lifecycle

    init(builder: RequestBuilder, decode: @escaping (Data) throws -> Response) {
        self.builder = builder
        self.decode = decode
    }

    // MARK: - Internal Methods

    func modifyRequest(_ f: (RequestBuilder) -> RequestBuilder) {
        self.builder = f(builder)
    }
}

// MARK: - Endpoint (URLResponseCapable)

extension Endpoint: URLResponseCapable {

    // MARK: - Types

    typealias ResponseType = Response

    // MARK: - Internal Methods

    func handle(data: Data) throws -> Response { try self.decode(data) }
}

// MARK: - Endpoint (URLRequestConvertible)

extension Endpoint: URLRequestConvertible {

    // MARK: - Internal Methods

    func asURLRequest() throws -> URLRequest {
        guard let request = try? builder.asURLRequest() else {
            fatalError("URLRequest failed")
        }
        return request
    }
}

// MARK: - Endpoint (Decodable)

extension Endpoint where Response: Swift.Decodable {
    convenience init(
        method: RequestBuilder.Method,
        path: String,
        decoder: JSONDecoder? = nil,
        requestType: RequestBuilder.RequestType = .request,
        _ builder: ((RequestBuilder) -> RequestBuilder)? = nil
    ) {
        var reqBuilder = RequestBuilder(method: method, path: path, requestType: requestType)
        if let builder = builder {
            reqBuilder = builder(reqBuilder)
        }

        let jsonDecoder = decoder ?? JSONDecoder()

        if decoder == nil {
            let fullISO8610Formatter = DateFormatter()
            fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            jsonDecoder.dateDecodingStrategy = .formatted(fullISO8610Formatter)
        }

        self.init(builder: reqBuilder) {
            do {
                return try jsonDecoder.decode(Response.self, from: $0)
            } catch {
                throw error
            }
        }
    }
}

// MARK: - Endpoint (String)

extension Endpoint where Response == String {
    convenience init(
        method: RequestBuilder.Method,
        path: String,
        decoder: JSONDecoder? = nil,
        requestType: RequestBuilder.RequestType = .upload,
        _ builder: ((RequestBuilder) -> RequestBuilder)? = nil
    ) {
        var reqBuilder = RequestBuilder(method: method, path: path, requestType: requestType)
        if let builder = builder {
            reqBuilder = builder(reqBuilder)
        }

        let jsonDecoder = decoder ?? JSONDecoder()

        self.init(builder: reqBuilder) {
            do {
                return try jsonDecoder.decode(Response.self, from: $0)
            } catch {
                throw error
            }
        }
    }
}