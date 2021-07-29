import Foundation
import PhoneNumberKit

enum PhoneHelper {
    private static let phoneNumberKit = PhoneNumberKit()

    static var userRegionCode: String { Locale.current.regionCode ?? "RU" }
    static var verificationCodeRequiredLength: Int { 4 }
    static var verificationCodeForTest: String { "1234" }
    static var verificationResendTime: Double { 30 }

    static func validatePhoneNumber(_ text: String, forRegion region: String) -> Bool {
        phoneNumberKit.isValidPhoneNumber(text, withRegion: region, ignoreType: true)
    }

    static func getDialCode(forPhoneNumber phoneNumber: String) -> String? {
        guard let phoneNumber = try? phoneNumberKit.parse(phoneNumber) else { return nil }
        return "+\(phoneNumber.countryCode)"
    }

    static func formatToNationalNumber(_ text: String, forRegion region: String) -> String? {
        formatText(text, forRegion: region, intoFormat: .national)
    }

    static func formatToInternationalNumber(_ text: String, forRegion region: String) -> String? {
        formatText(text, forRegion: region, intoFormat: .international)
    }

    static func formatText(_ text: String, forRegion region: String, intoFormat format: PhoneNumberFormat) -> String? {
        if let phoneNumber = try? phoneNumberKit.parse(text, withRegion: region, ignoreType: true) {
            return phoneNumberKit.format(phoneNumber, toType: format, withPrefix: false)
        }
        return nil
    }
}
