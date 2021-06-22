import Foundation

// MARK: - APIClientService

protocol APIClientManager {
    @discardableResult
    func request<Requestable>(
        _ requestConvertible: Endpoint<Requestable>,
        success: @escaping (Requestable) -> Void,
        failure: @escaping (Error) -> Void
    ) -> URLSessionDataTask
}

// MARK: - APIClient

final class APIClient: NSObject, APIClientManager {

    // MARK: - Private Properties

    private var additionalHeaders: [String: String] = [:]
    private var session = URLSession(configuration: .default)

    // MARK: - Lifecycle

    required init(configuration: URLSessionConfiguration = .default) {
        super.init()
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.configuration.timeoutIntervalForRequest = 10
        session.configuration.timeoutIntervalForResource = 10
    }

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

    // MARK: - Internal Methods

    func additionalHeaders(_ headers: [String: String]) {
        additionalHeaders.merge(headers, uniquingKeysWith: { $1 })
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

        if UserDefaultsLayer.storage.auth.isUserAuthenticated {
            httpRequest.addValue("\(UserDefaultsLayer.storage.auth.token)", forHTTPHeaderField: "X-TN")
        }

        let task: URLSessionDataTask = session.dataTask(with: httpRequest) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.isOk else {
                    handler(.failure(APIError(statusCode: httpResponse.statusCode, data: data)))
                    return
                }
                do {
                    let parsedResponse = try requestConvertible.handle(data: data)
                    handler(.success(parsedResponse))
                } catch {
                    handler(.failure(error))
                }
            } else if let error = error {
                handler(.failure(error))
            }
        }

        task.resume()
        return task
    }
}

// MARK: - APIClient (URLSessionDelegate)

extension APIClient: URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        guard let url = request.url else {
            DispatchQueue.main.async {
                completionHandler(request)
            }
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.setValue("Bearer ", forHTTPHeaderField: "Authorization")
        DispatchQueue.main.async {
            completionHandler(urlRequest)
        }
    }
}
