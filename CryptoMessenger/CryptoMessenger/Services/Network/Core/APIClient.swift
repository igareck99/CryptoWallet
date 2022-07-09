import Combine
import Foundation

// MARK: - Type

typealias TryMapPublisher = Publishers.TryMap
typealias DataTaskPublisher = URLSession.DataTaskPublisher

// MARK: - APIClientManager

protocol APIClientManager {
    func publisher<Requestable>(_ requestConvertible: Endpoint<Requestable>) -> AnyPublisher<Requestable, Error>
}

// MARK: - APIClient

final class APIClient: NSObject, APIClientManager {

    // MARK: - Internal Properties

    var logLevel: APILogLevel = .debug {
        didSet { logger.logLevel = logLevel }
    }

    // MARK: - Private Properties

    private var session = URLSession(configuration: .default)
    private let authenticator: Authenticator
    private let queue = DispatchQueue(label: "APIClient.\(UUID().uuidString)")
    private let logger: APILogger = .shared
    private var isTokenUpdated = false

    // MARK: - Life Cycle

    required init(configuration: URLSessionConfiguration = .default) {
		let keychainService = KeychainService.shared
		self.authenticator = Authenticator(
			keychainService: keychainService,
			session: session
		)
        super.init()
        session = URLSession(configuration: configuration)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.configuration.timeoutIntervalForRequest = 120
        session.configuration.timeoutIntervalForResource = 120
    }

    // MARK: - Internal Methods

    func publisher<Requestable>(_ requestConvertible: Endpoint<Requestable>) -> AnyPublisher<Requestable, Error> {
        guard let httpRequest = try? requestConvertible.asURLRequest() else {
            return Fail(error: APIError.apiError(-1, nil) as Error)
                .eraseToAnyPublisher()
        }

        return authenticator.validToken()
            .flatMap { token in
                // we can now use this token to authenticate the request
                self.session.dataTaskPublisher(for: httpRequest, token: token.isUserAuthenticated ? token : nil)
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                if let error = error as? URLError, error.code == .notConnectedToInternet {
                    throw APIError.notConnectedToInternet
                } else if let error = error as? APIError {
                    switch error {
                    case .apiError(let statusCode, _):
                        if 500...599 ~= statusCode {
                            throw APIError.serverError
                        } else if statusCode == 401 {
                            return self.authenticator.validToken(forceRefresh: true)
                                .flatMap { token in
                                    // we can now use this new token to authenticate the second attempt at making this request
                                    self.session.dataTaskPublisher(for: httpRequest, token: token)
                                }
                                .eraseToAnyPublisher()
                        } else if statusCode == 400 {
                            throw APIError.invalidToken
                        } else {
                            throw error as Error
                        }
                    default:
                        throw APIError.serverError
                    }
                }

                throw error
            }
            .tryMap { try requestConvertible.handle(data: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - URLSession ()

extension URLSession {

    // MARK: - Internal Methods

    func dataTaskPublisher(for urlRequest: URLRequest, token: Token?) -> AnyPublisher<Data, Error> {
        var request = urlRequest
        if let token = token {
            request.setValue("Bearer \(token.access)", forHTTPHeaderField: "Authorization")
        }

        APILogger.shared.log(request: request)

        return dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                APILogger.shared.log(response: result.response, data: result.data)
                let statusCode = (result.response as? HTTPURLResponse)?.statusCode ?? 0

                if 200...299 ~= statusCode {
                    return result.data
                } else {
                    throw APIError.apiError(statusCode, result.data)
                }
            }
            .eraseToAnyPublisher()
    }
}
