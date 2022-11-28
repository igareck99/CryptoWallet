import Foundation

// MARK: - PinCodeScreenType

enum PinCodeScreenType: Hashable {

    case pinCodeCreate
    case falsePinCode
    case approvePinCode

    var result: (title: String, description: String) {
        switch self {
        case .pinCodeCreate:
            return (R.string.localizable.pinCodeEnterPassword(),
                    R.string.localizable.pinCodeCreateText())
        case .falsePinCode:
            return (R.string.localizable.pinCodeFalseTitle(),
                    R.string.localizable.pinCodeFalseText())
        case .approvePinCode:
            return (R.string.localizable.pinCodeEnterPassword(),
                    "")
        }
    }
}
