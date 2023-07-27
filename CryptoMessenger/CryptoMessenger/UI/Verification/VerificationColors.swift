import SwiftUI

protocol VerificationColorable: OtpViewColorable {
    var titleColor: Binding<Color> { get set }
    var subtitleColor: Binding<Color> { get set }
    var codeStrokeColor: Binding<Color> { get set }
    var codeFillColor: Binding<Color> { get set }
    var codeTextColor: Binding<Color> { get set }
    var hyphenColor: Binding<Color> { get set }
    var errorTextColor: Binding<Color> { get set }
    var resendTextColor: Binding<Color> { get set }
}

final class VerificationColors: VerificationColorable {
    var titleColor: Binding<Color> = .constant(.chineseBlack)
    var subtitleColor: Binding<Color> = .constant(.romanSilver)
    // empty: .clear
    // filled: .dodgerBlue
    // invalid: .spanishCrimson
    var codeStrokeColor: Binding<Color> = .constant(.clear)
    var codeFillColor: Binding<Color> = .constant(.aliceBlue)
    var codeTextColor: Binding<Color> = .constant(.chineseBlack)
    // empty: .clear ???
    var hyphenColor: Binding<Color> = .constant(.chineseBlack)
    var errorTextColor: Binding<Color> = .constant(.spanishCrimson)
    var resendTextColor: Binding<Color> = .constant(.dodgerBlue)
}
