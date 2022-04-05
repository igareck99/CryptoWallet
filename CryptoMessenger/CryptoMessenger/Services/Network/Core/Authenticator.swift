import Combine
import Foundation

// MARK: - Token

struct Token {

    // MARK: - Internal Properties

    var isUserAuthenticated = false
    var access = ""
    var refresh = ""
}

// MARK: - Authenticator

final class Authenticator {

    // MARK: - AuthenticationError

    enum AuthenticationError: Error {

        // MARK: - Types

        case loginRequired
    }

    // MARK: - Private Properties

    private let session: URLSession
    private let queue = DispatchQueue(label: "Authenticator.\(UUID().uuidString)")
    private var refreshPublisher: AnyPublisher<Token, Error>?
    @Injectable private var userCredentialsStorage: UserCredentialsStorageService

    // MARK: - Life Cycle

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Internal Methods

    func validToken(forceRefresh: Bool = false) -> AnyPublisher<Token, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }

            // scenario 2: we don't have a token at all, the user should probably log in
            guard
                let access = self?.userCredentialsStorage.accessToken,
                let refresh = self?.userCredentialsStorage.refreshToken,
                !access.isEmpty
            else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }

            // scenario 3: we already have a valid token and don't want to force a refresh
            if !forceRefresh {
                return Just(Token(isUserAuthenticated: true, access: access, refresh: refresh))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            let requestConvertible = Endpoints.Session.refresh(self?.userCredentialsStorage.refreshToken ?? "")
            guard let httpRequest = try? requestConvertible.asURLRequest() else {
                return Fail(error: APIError.apiError(-1, nil) as Error)
                    .eraseToAnyPublisher()
            }

            // scenario 4: we need a new token
            let publisher = session
                .dataTaskPublisher(for: httpRequest, token: nil)
                .share()
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .map {
                    Token(isUserAuthenticated: true, access: $0.accessToken, refresh: $0.refreshToken)
                }
                .handleEvents(receiveOutput: { token in
                    self?.userCredentialsStorage.accessToken = token.access
                    self?.userCredentialsStorage.refreshToken = token.refresh
                    self?.userCredentialsStorage.isUserAuthenticated = token.isUserAuthenticated
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
