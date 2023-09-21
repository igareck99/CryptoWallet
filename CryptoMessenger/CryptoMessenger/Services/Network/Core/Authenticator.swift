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
	private let keychainService: KeychainServiceProtocol

    // MARK: - Life Cycle

    init(
        session: URLSession = .shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared
	) {
        self.session = session
		self.keychainService = keychainService
    }

    // MARK: - Internal Methods

    func validToken(forceRefresh: Bool = false) -> AnyPublisher<Token, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }

            // scenario 2: we don't need a token at all
            guard
                let access = self?.keychainService.apiAccessToken,
                let refresh = self?.keychainService.apiRefreshToken,
                !access.isEmpty
            else {
                return Just(Token())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            // scenario 3: we already have a valid token and don't want to force a refresh
            if !forceRefresh {
                return Just(Token(isUserAuthenticated: true, access: access, refresh: refresh))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            guard let refreshToken = self?.keychainService.apiRefreshToken
            else {
                return Fail(error: APIError.noRefreshToken as Error)
                    .eraseToAnyPublisher()
            }

            let requestConvertible = Endpoints.Session.refresh(refreshToken)
            guard let httpRequest = try? requestConvertible.asURLRequest() else {
                return Fail(error: APIError.apiError(-1, nil) as Error)
                    .eraseToAnyPublisher()
            }

            // scenario 4: we need a new token
            let publisher = self?.session
                .dataTaskPublisher(for: httpRequest, token: nil)
                .share()
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .map {
                    Token(isUserAuthenticated: true, access: $0.accessToken, refresh: $0.refreshToken)
                }
                .handleEvents(receiveOutput: { [weak self] token in
                    self?.keychainService.apiAccessToken = token.access
                    self?.keychainService.apiRefreshToken = token.refresh
                    self?.keychainService.isApiUserAuthenticated = token.isUserAuthenticated
                    self?.notifyTokenUpdate()
                }, receiveCompletion: { [weak self] _ in
                    self?.queue.sync { [weak self] in
                        self?.refreshPublisher = nil
                    }
                })
                .eraseToAnyPublisher()

            guard let unwrappedPublisher = publisher
            else {
                return Fail(error: APIError.publisherCreationFailure as Error)
                    .eraseToAnyPublisher()
            }
            self?.refreshPublisher = unwrappedPublisher
            return unwrappedPublisher
        }
    }

    private func notifyTokenUpdate() {
        NotificationCenter
            .default
            .post(
                name: .didRefreshToken,
                object: nil
            )
    }
}
