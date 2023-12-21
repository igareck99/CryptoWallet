import Foundation

protocol CodeVerificationResourcable {
    static var typeCode: String { get }
    static var codeSentOn: String { get }
    static var resendText: String { get }
    static var seconds: String { get }
    static var wrongOTP: String { get }
    static var resendCode: String { get }
}

// MARK: - CodeVerificationResourcable

enum CodeVerificationResources: CodeVerificationResourcable {
    static var typeCode: String {
        R.string.localizable.verificationTitle()
    }

    static var codeSentOn: String {
        R.string.localizable.verificationCodeWasSent()
    }

    static var resendText: String {
        R.string.localizable.verificationResendCodeAgain()
    }

    static var seconds: String {
        R.string.localizable.verificationSeconds()
    }

    static var wrongOTP: String {
        R.string.localizable.verificationWrongOTP()
    }
    
    static var resendCode: String {
        R.string.localizable.verificationResendCode()
    }
}
