import SwiftUI

// MARK: - AboutAppSourcesable

protocol AboutAppSourcesable {

    static var auraLogo: Image { get }

    static var politicConfidence: String { get }

    static var nameApp: String { get }
    
    static var aboutApp: String { get }
    
    static var uasgeConditions: String { get }
    
    static var titleColor: Color { get }
    
    static var textColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var background: Color { get }
}

// MARK: - AboutAppSources(AboutAppSourcesable)

enum AboutAppSources: AboutAppSourcesable {

    static var auraLogo: Image {
        R.image.pinCode.aura.image
    }

    static var politicConfidence: String {
        R.string.localizable.aboutAppTermsAndPolitics()
    }

    static var nameApp: String {
        R.string.localizable.aboutAppAppName()
    }

    static var usageCondition: String {
        R.string.localizable.aboutAppUsageCondition()
    }
    
    static var aboutApp: String {
        R.string.localizable.aboutAppTitle()
    }
    
    static var uasgeConditions: String {
        R.string.localizable.aboutAppUsageCondition()
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var background: Color {
        .white 
    }
}
