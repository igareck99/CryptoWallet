import Foundation

// MARK: - APILogLevel

enum APILogLevel {

    // MARK: - Types

    case off
    case info
    case debug
}

// MARK: - APILogLevel

final class APILogger {

    // MARK: - Internal Properties

    var logLevel = APILogLevel.debug

    // MARK: - Internal Methods

    func log(request: URLRequest) {
        guard logLevel != .off else { return }

        if let method = request.httpMethod,
            let url = request.url {
            print("\(method) '\(url.absoluteString)'")
            logHeaders(request)
            logBody(request)
        }

        if logLevel == .debug {
            logCurl(request)
        }
    }

    func log(response: URLResponse?, data: Data?) {
        guard logLevel != .off else { return }

        if let response = response as? HTTPURLResponse {
            logStatusCodeAndURL(response)
        }
        if logLevel == .debug, let data = data {
            print(String(decoding: data, as: UTF8.self))
        }
    }

    // MARK: - Private Methods

    private func logHeaders(_ urlRequest: URLRequest) {
        guard let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields else { return }
        allHTTPHeaderFields.forEach { key, value  in
            print("  \(key) : \(value)")
        }
    }

    private func logBody(_ urlRequest: URLRequest) {
        guard let body = urlRequest.httpBody, let str = String(data: body, encoding: .utf8) else { return }
        print("  HttpBody : \(str)")
    }

    private func logStatusCodeAndURL(_ urlResponse: HTTPURLResponse) {
        if let url = urlResponse.url {
            print("\(urlResponse.statusCode) '\(url.absoluteString)'")
        }
    }

    private func logCurl(_ urlRequest: URLRequest) {
        print(urlRequest.toCurlCommand())
    }
}

// MARK: - URLRequest ()

private extension URLRequest {

    // MARK: - Internal Methods

    func toCurlCommand() -> String {
        guard let url = url else { return "" }

        var command = ["curl \"\(url.absoluteString)\""]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        allHTTPHeaderFields?
            .filter { $0.key != "Cookie" }
            .forEach { command.append("-H '\($0.key): \($0.value)'") }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}