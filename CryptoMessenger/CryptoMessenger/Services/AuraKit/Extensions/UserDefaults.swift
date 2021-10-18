import Foundation

public extension UserDefaults {
    private static let appGroup: String = {
        guard let group = Bundle.main.infoDictionary?["AppGroup"] as? String else {
            fatalError("Missing 'AppGroup' key in Info.plist!")
        }
        return group
    }()

    private static let suiteName = "group." + appGroup

    static let group = UserDefaults(suiteName: suiteName)!
}
