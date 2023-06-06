import Foundation

// MARK: - PinCodeScreenType

enum PinCodeScreenType: Hashable {

    case login
    case pinCodeCreate
    case pinCodeRemove
    case biometry
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
        case .biometry:
            return ("", "")
        case .login:
            return ("", "")
        case .pinCodeRemove:
            return ("", "")
        }
    }
}
