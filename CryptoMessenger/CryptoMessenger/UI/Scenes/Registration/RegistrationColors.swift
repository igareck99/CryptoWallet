import SwiftUI

protocol RegistrationColorable: ObservableObject {

    var titleColor: Binding<Color> { get set }
    var subtitleColor: Binding<Color> { get set }

    var phoneSignColor: Binding<Color> { get set }
    var phoneBackColor: Binding<Color> { get set }

    var sendButtonColor: Binding<Color> { get set }
    var buttonTextColor: Binding<Color> { get set }
    var buttonLoaderColor: Binding<Color> { get set }

    var selectCountryTextColor: Binding<Color> { get set }
    var selectCountryChevronColor: Binding<Color> { get set }
    var selectCountryBackColor: Binding<Color> { get set }
    var selectCountryStrokeColor: Binding<Color> { get set }
    var selectCountryErrorColor: Binding<Color> { get set }
}

final class RegistrationColors: RegistrationColorable {
    var titleColor: Binding<Color> = .constant(.chineseBlack)
    var subtitleColor: Binding<Color> = .constant(.romanSilver)

    var phoneSignColor: Binding<Color> = .constant(.chineseBlack)
    var phoneBackColor: Binding<Color> = .constant(.aliceBlue)

    var sendButtonColor: Binding<Color> = .constant(.ghostWhite) // dodgerBlue (enabled state)
    var buttonTextColor: Binding<Color> = .constant(.ashGray) // .white (enabled state)
    var buttonLoaderColor: Binding<Color> = .constant(.white) // .white (enabled state)

    var selectCountryTextColor: Binding<Color> = .constant(.chineseBlack)
    var selectCountryChevronColor: Binding<Color> = .constant(.chineseBlack)
    var selectCountryBackColor: Binding<Color> = .constant(.aliceBlue)
    var selectCountryStrokeColor: Binding<Color> = .constant(.clear) // spanishCrimson
    var selectCountryErrorColor: Binding<Color> = .constant(.clear) // spanishCrimson
}
