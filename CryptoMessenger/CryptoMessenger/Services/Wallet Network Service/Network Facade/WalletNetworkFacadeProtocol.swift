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
}
