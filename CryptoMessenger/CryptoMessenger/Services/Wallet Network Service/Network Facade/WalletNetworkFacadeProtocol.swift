import Foundation

protocol WalletNetworkFacadeProtocol {
    func getTokens(
        params: NetworkTokensRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<NetworkTokensResponse>>
    )
    
    func getNetworks(
        completion: @escaping GenericBlock<EmptyFailureResult<WalletNetworkResponse>>
    )
    
    func getAddress(
        params: AddressRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<AddressResponse>>
    )
    
    func getBalances(
        params: BalanceRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<BalancesResponse>>
    )
    
    func getTransactions(
        params: TransactionsRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<WalletsTransactionsResponse>>
    )
    
    func getFee(
        params: FeeRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<FeeResponse>>
    )
    
    func makeTransactionTemplate(
        params: TransactionTemplateRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<TransactionTemplateResponse>>
    )
    
    func makeTransactionSend(
        params: TransactionSendRequestParams,
        completion: @escaping GenericBlock<EmptyFailureResult<TransactionSendResponse>>
    )
    
    // MARK: - ASYNC

    func requestTokens(
        params: NetworkTokensRequestParams
    ) async -> GenericResponse<NetworkTokensResponse?>

    func requestNetworks() async -> GenericResponse<WalletNetworkResponse?>

    func requestAddress(
        params: AddressRequestParams
    ) async -> GenericResponse<AddressResponse?>

    func requestBalances(
        params: BalanceRequestParams
    ) async -> GenericResponse<BalancesResponse?>

    func requestTransactions(
        params: TransactionsRequestParams
    ) async -> GenericResponse<WalletsTransactionsResponse?>

    func requestFee(
        params: FeeRequestParams
    ) async -> GenericResponse<FeeResponse?>

    func requestTransactionTemplate(
        params: TransactionTemplateRequestParams
    ) async -> GenericResponse<TransactionTemplateResponse?>

    func requestTransactionSend(
        params: TransactionSendRequestParams
    ) async -> GenericResponse<TransactionSendResponse?>
}
