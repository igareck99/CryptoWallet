import Foundation

extension WalletNetworkFacade {

    // MARK: - Tokens

    func requestTokens(
        params: NetworkTokensRequestParams
    ) async -> GenericResponse<NetworkTokensResponse?> {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildTokens(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: NetworkTokensResponse.self
        )
        return response
    }

    // MARK: - Network Wallets

    func requestNetworks() async -> GenericResponse<WalletNetworkResponse?> {
        let request = walletRequestsFactory.buildNetworks(parameters: [:])
        let urlRequest = networkRequestFactory.makeGetRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: WalletNetworkResponse.self
        )
        return response
    }

    // MARK: - Address

    func requestAddress(
        params: AddressRequestParams
    ) async -> GenericResponse<AddressResponse?> {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildAddress(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: AddressResponse.self
        )
        return response
    }

    // MARK: - Balances

    func requestBalances(
        params: BalanceRequestParams
    ) async -> GenericResponse<BalancesResponse?> {
        let paramsDict: [String: Any] = params.makeParamsDict()
        let request = walletRequestsFactory.buildBalances(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: BalancesResponse.self
        )
        return response
    }

    // MARK: - Transactions

    func requestTransactions(
        params: TransactionsRequestParams
    ) async -> GenericResponse<WalletsTransactionsResponse?> {
        let paramsDict: [String: Any] = params.makeRequestDict()
        let request = walletRequestsFactory.buildTransactions(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: WalletsTransactionsResponse.self
        )
        return response
    }

    // MARK: - Fee

    func requestFee(
        params: FeeRequestParams
    ) async -> GenericResponse<FeeResponse?> {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildFee(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: FeeResponse.self
        )
        return response
    }

    // MARK: - Transaction template

    func requestTransactionTemplate(
        params: TransactionTemplateRequestParams
    ) async -> GenericResponse<TransactionTemplateResponse?> {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildTransactionTemplate(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: TransactionTemplateResponse.self
        )
        return response
    }

    // MARK: - Transaction Send

    func requestTransactionSend(
        params: TransactionSendRequestParams
    ) async -> GenericResponse<TransactionSendResponse?> {
        let paramsDict: [String: Any] = params.dictionary
        let request = walletRequestsFactory.buildTransactionSend(parameters: paramsDict)
        let urlRequest = networkRequestFactory.makePostRequest(from: request)
        let response = await send(
            request: urlRequest,
            parseType: TransactionSendResponse.self
        )
        return response
    }

    func send<T: Codable>(
        request: URLRequest,
        parseType: T.Type
    ) async -> GenericResponse<T> {
        let response = await networkService.send(request: request)
        logReponse("\(#function)", response.data, response.response, response.error)

        guard
            response.response?.isSuccess == true,
            let data = response.data,
            let model = Parser.parse(data: data, to: parseType.self)
        else {
            return (nil, NetworkFacadeError.parseFailed)
        }
        return (model, nil)
    }

    func sendRequest(_ request: URLRequest) async -> EmptyResult {
        let response = await networkService.send(request: request)
        logReponse("\(#function)", response.data, response.response, response.error)
        guard response.response?.isSuccess == true else { return .failure }
        return .success
    }
}
