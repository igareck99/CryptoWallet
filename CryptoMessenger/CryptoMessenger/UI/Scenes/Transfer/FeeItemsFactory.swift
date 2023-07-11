import Foundation

protocol FeeItemsFactoryProtocol {
    static func make(
        feesModel: FeeResponse,
        sources: TransferViewSourcable.Type,
        currency: String
    ) -> [TransactionSpeed]
}

enum FeeItemsFactory: FeeItemsFactoryProtocol {
    static func make(
        feesModel: FeeResponse,
        sources: TransferViewSourcable.Type,
        currency: String
    ) -> [TransactionSpeed] {
        let slow = TransactionSpeed(
            title: sources.transferSlow,
            feeText: "\(feesModel.fee.slow) \(currency)",
            feeValue: "\(feesModel.fee.slow)",
            mode: .slow
        )

        let medium = TransactionSpeed(
            title: sources.transferMiddle,
            feeText: "\(feesModel.fee.average) \(currency)",
            feeValue: "\(feesModel.fee.average)",
            mode: .medium
        )

        let fast = TransactionSpeed(
            title: sources.transferFast,
            feeText: "\(feesModel.fee.fast) \(currency)",
            feeValue: "\(feesModel.fee.fast)",
            mode: .fast
        )
        return [slow, medium, fast]
    }
}
