import UIKit

// MARK: - Transaction

struct Transaction {

    // MARK: - Internal Properties

    let cryptocurrency: String
    let currency: String
    let type: TransactionType
    let date: String

    // MARK: - TransactionType

    enum TransactionType {
        case inflow
        case writeOff

        var name: String {
            switch self {
            case .inflow:
                return "Получено"
            case .writeOff:
                return "Отправлено"
            }
        }

        var icon: UIImage? {
            switch self {
            case .inflow:
                return R.image.wallet.inflow()
            case .writeOff:
                return R.image.wallet.writeOff()
            }
        }

        var color: Palette {
            switch self {
            case .inflow:
                return .green()
            case .writeOff:
                return .blue()
            }
        }
    }
}
