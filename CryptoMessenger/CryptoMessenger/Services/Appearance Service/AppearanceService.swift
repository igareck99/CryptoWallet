import Foundation
import SwiftUI

class Utilities {
    
    // MARK: - Internal Properties
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    var userInterfaceStyle: ColorScheme? = .dark
    
    func overrideDisplayMode() {
        var userInterfaceStyle: UIUserInterfaceStyle
        
        if selectedAppearance == 2 {
            userInterfaceStyle = .dark
        } else if selectedAppearance == 1 {
            userInterfaceStyle = .light
        } else {
            userInterfaceStyle = .unspecified
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}
