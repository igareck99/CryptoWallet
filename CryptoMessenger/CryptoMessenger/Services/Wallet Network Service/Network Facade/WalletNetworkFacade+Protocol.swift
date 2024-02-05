import Foundation

// MARK: - WalletNetworkFacadeProtocol

extension WalletNetworkFacade: WalletNetworkFacadeProtocol {

    // MARK: - Tokens

    func getTokens(
        params: NetworkTokensRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<NetworkTokensResponse>>
    ) {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildTokens(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("getTokens", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: NetworkTokensResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Network Wallets

    func getNetworks(completion: @escaping GenericBlock<EmptyFailureResult<WalletNetworkResponse>>) {
        let request = walletRequestsFactory.buildNetworks(parameters: [:])
        let urlRequest = networkRequestFactory.makeGetRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("getNetworks", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: WalletNetworkResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Address

    func getAddress(
        params: AddressRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
    ) {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildAddress(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("getAddress", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: AddressResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Balances

    func getBalances(
        params: BalanceRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
    ) {
        let paramsDict: [String: Any] = params.makeParamsDict()
        let request = walletRequestsFactory.buildBalances(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("getBalances", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: BalancesResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Transactions

    func getTransactions(
        params: TransactionsRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<WalletsTransactionsResponse>>
    ) {
        let paramsDict: [String: Any] = params.makeRequestDict()
        let request = walletRequestsFactory.buildTransactions(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("getTransactions", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: WalletsTransactionsResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Fee

    func getFee(
        params: FeeRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<FeeResponse>>
    ) {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildFee(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("getFee", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: FeeResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Transaction template

    func makeTransactionTemplate(
        params: TransactionTemplateRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<TransactionTemplateResponse>>
    ) {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildTransactionTemplate(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("makeTransactionTemplate", data, response, error)
            guard
                let data = data,
                let model = Parser.parse(data: data, to: TransactionTemplateResponse.self)
            else {
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }

    // MARK: - Transaction Send

    func makeTransactionSend(
        params: TransactionSendRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<TransactionSendResponse>>
    ) {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildTransactionSend(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        send(request: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logReponse("makeTransactionSend", data, response, error)
            guard let data = data,
                  let model = Parser.parse(data: data, to: TransactionSendResponse.self)
            else {
                self.parseErrorMessage(data: data)
                completion(.failure)
                return
            }
            completion(.success(model))
        }
    }
}
