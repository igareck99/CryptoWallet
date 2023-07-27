import SwiftUI

// MARK: - AboutAppSourcesable

protocol AboutAppSourcesable {

    static var auraLogo: Image { get }

    static var politicConfidence: String { get }

    static var nameApp: String { get }
    
    static var aboutApp: String { get }
    
    static var uasgeConditions: String { get }
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
}
