import Combine
import Foundation

// MARK: - Type

typealias TryMapPublisher = Publishers.TryMap
typealias DataTaskPublisher = URLSession.DataTaskPublisher

// MARK: - APIClientManager

protocol APIClientManager {
    @discardableResult
    func request<Requestable>(
        _ requestConvertible: Endpoint<Requestable>,
        success: @escaping (Requestable) -> Void,
        failure: @escaping (Error) -> Void
    ) -> URLSessionDataTask

    func publisher<Requestable>(_ requestConvertible: Endpoint<Requestable>) -> AnyPublisher<Requestable, Error>
    func dataTaskPublisher(for httpRequest: URLRequest) -> TryMapPublisher<DataTaskPublisher, Data>
}

// MARK: - APIClient

final class APIClient: NSObject, APIClientManager {

    // MARK: - Constants

    private enum Constants {

        // MARK: - Static Properties

        static let defaultRetryDelay: DispatchQueue.SchedulerTimeType.Stride = 1
    }

    // MARK: - Internal Properties

    var logLevel: APILogLevel = .debug {
        didSet {
            logger.logLevel = logLevel
        }
    }

    // MARK: - Private Properties

    private var additionalHeaders: [String: String] = [:]
    private var session = URLSession(configuration: .default)
    private var refreshPublisher: AnyPublisher<AuthResponse, Error>?
    @Injectable private var userCredentialsStorage: UserCredentialsStorageService
    private let queue = DispatchQueue(label: "APIClient. \(UUID().uuidString)")
    private let logger = APILogger()

    // MARK: - Lifecycle

    required init(configuration: URLSessionConfiguration = .default) {
        super.init()
        session = URLSession(configuration: configuration)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.configuration.timeoutIntervalForRequest = 120
        session.configuration.timeoutIntervalForResource = 120
    }

    // MARK: - Internal Methods

    @discardableResult
    func request<Requestable>(
        _ requestConvertible: Endpoint<Requestable>,
        success: @escaping (Requestable) -> Void,
        failure: @escaping (Error) -> Void
    ) -> URLSessionDataTask {
        request(requestConvertible) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    success(response)
                }
            }
        }
    }

    func publisher<Requestable>(_ requestConvertible: Endpoint<Requestable>) -> AnyPublisher<Requestable, Error> {
        guard var httpRequest = try? requestConvertible.asURLRequest() else {
            return Fail(error: APIError.apiError(-1, nil) as Error)
                .eraseToAnyPublisher()
        }

        additionalHeaders.forEach { header, value in
            httpRequest.addValue(value, forHTTPHeaderField: header)
        }

        if userCredentialsStorage.isUserAuthenticated {
            httpRequest.addValue("Bearer \(userCredentialsStorage.accessToken)", forHTTPHeaderField: "Authorization")
        }

        return dataTaskPublisher(for: httpRequest)
            .tryCatch { [weak self] error -> AnyPublisher<Data, Error> in
                if let error = error as? URLError, error.code == .notConnectedToInternet {
                    throw APIError.notConnectedToInternet
                } else if let error = error as? APIError {
                    switch error {
                    case .apiError(let statusCode, _):
                        if 500...599 ~= statusCode {
                            return Fail(error: APIError.serverError as Error)
                                .delay(for: Constants.defaultRetryDelay, scheduler: DispatchQueue.main)
                                .eraseToAnyPublisher()
                        } else if statusCode == 401 {
                            if let self = self {
                                return self.refreshToken()
                                    .map { _ in
                                        var newHttpRequest = httpRequest
                                        newHttpRequest.setValue(
                                            "Bearer \(self.userCredentialsStorage.accessToken)",
                                            forHTTPHeaderField: "Authorization"
                                        )
                                        return newHttpRequest
                                    }
                                    .flatMap { newHttpRequest in
                                        return self.dataTaskPublisher(for: newHttpRequest)
                                    }
                                    .eraseToAnyPublisher()
                            }
                        } else {
                            return Fail(error: error as Error)
                                .delay(for: Constants.defaultRetryDelay, scheduler: DispatchQueue.main)
                                .eraseToAnyPublisher()
                        }
                    default:
                        return Fail(error: error as Error)
                            .delay(for: Constants.defaultRetryDelay, scheduler: DispatchQueue.main)
                            .eraseToAnyPublisher()
                    }
                }

                throw error
            }
            .retry(1, if: { error in
                guard let error = error as? APIError else { return true }
                switch error {
                case .apiError(let statusCode, _):
                    return statusCode != 401
                default:
                    return true
                }
            })
            .tryMap {
                try requestConvertible.handle(data: $0)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func additionalHeaders(_ headers: [String: String]) {
        additionalHeaders.merge(headers, uniquingKeysWith: { $1 })
    }

    func dataTaskPublisher(for httpRequest: URLRequest) -> TryMapPublisher<DataTaskPublisher, Data> {
        logger.log(request: httpRequest)
        return session.dataTaskPublisher(for: httpRequest)
            .tryMap { data, response -> Data in
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        throw APIError.apiError(httpURLResponse.statusCode, data)
                    }
                }
                return data
            }
    }

    // MARK: - Private Methods

    private func request<Requestable>(
        _ requestConvertible: Endpoint<Requestable>,
        handler: @escaping (Result<Requestable, Error>) -> Void
    ) -> URLSessionDataTask {
        guard var httpRequest = try? requestConvertible.asURLRequest() else {
            fatalError("Request convertible failed")
        }

        additionalHeaders.forEach { header, value in
            httpRequest.addValue(value, forHTTPHeaderField: header)
        }

        if userCredentialsStorage.isUserAuthenticated {
            httpRequest.addValue("Bearer \(userCredentialsStorage.accessToken)", forHTTPHeaderField: "Authorization")
        }

        logger.log(request: httpRequest)

        let task: URLSessionDataTask = session.dataTask(with: httpRequest) { data, response, error in
            self.logger.log(response: response, data: data)

            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                if let error = error { handler(.failure(error)) }
                return
            }

            guard httpResponse.isOk else {
                handler(.failure(APIError.apiError(httpResponse.statusCode, data)))
                return
            }

            do {
                let parsedResponse = try requestConvertible.handle(data: data)
                handler(.success(parsedResponse))
            } catch {
                handler(.failure(error))
            }
        }

        task.resume()
        return task
    }

    private func refreshToken() -> AnyPublisher<AuthResponse, Error> {
        queue.sync { [weak self] in
            if let publisher = self?.refreshPublisher {
                return publisher
            }

            //userCredentialsStorage.isUserAuthenticated = false

            let publisher = publisher(
                Endpoints.Session.refresh(userCredentialsStorage.refreshToken)
            )
                .handleEvents(receiveOutput: { auth in
                    self?.userCredentialsStorage.accessToken = auth.accessToken
                    self?.userCredentialsStorage.refreshToken = auth.refreshToken
                    self?.userCredentialsStorage.isUserAuthenticated = true
                }, receiveCompletion: { _ in
                    self?.queue.sync {
                        self?.refreshPublisher = nil
                    }
                })
                .eraseToAnyPublisher()

            self?.refreshPublisher = publisher
            return publisher
        }
    }
}
