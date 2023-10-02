import Foundation

extension WalletNetworkFacade {

    func send(
        request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        networkService.send(request: request) { [weak self] data, response, error in
            self?.checkIfRefreshNeeded(response: response) {
                completion(data, response, error)
            }
        }
    }

    func refreshAuth(
        refreshToken: String,
        completion: @escaping BaseNetworkRequestCompletion
    ) {
        let request = requestsFactory.makeRefresh(refreshToken: refreshToken)
        guard let urlRequest = networkRequestFactory.makePostRequest(from: request) else {
            completion(nil, nil, nil)
            return
        }
        networkService.send(request: urlRequest, completion: completion)
    }

    func checkIfRefreshNeeded(
        response: URLResponse?,
        completion: @escaping () -> Void
    ) {
        guard response?.isRefreshNeeded == true else {
            completion()
            return
        }
        
        // Refresh token is not presented in keychain ???
        guard let refreshToken = keychainService.refreshToken else {
            completion()
            return
        }
        
        refreshAuth(refreshToken: refreshToken) { [weak self] data, response, error in
            self?.logReponse("refreshAuth(refreshToken:,completion:)", data, response, error)
            
            if response?.isRefreshNeeded == true {
                completion()
                return
            }
            
            guard
                let self = self,
                response?.isRefreshNeeded == false,
                let data = data,
                let model = Parser.parse(data: data, to: AuthResponse.self),
                let accessToken = model.data?.accessToken
            else {
                self?.checkIfRefreshNeeded(response: response, completion: completion)
                return
            }
            self.keychainService.accessToken = accessToken
            if let refreshToken = model.data?.refreshToken {
                self.keychainService.refreshToken = refreshToken
            }
            completion()
        }
    }
}
