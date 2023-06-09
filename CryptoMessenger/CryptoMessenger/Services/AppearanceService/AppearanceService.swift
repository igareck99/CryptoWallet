import Foundation
import SwiftUI

class appearanceService {
    
    // MARK: - Internal Properties
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    var userInterfaceStyle: ColorScheme? = .dark
    
    func overrideDisplayMode() {
        var userInterfaceStyle: UIUserInterfaceStyle
        
        if selectedAppearance == 2 {
            userInterfaceStyle = .dark
            Color.customtheme = 2
        } else if selectedAppearance == 1 {
            userInterfaceStyle = .light
            Color.customtheme = 1
        } else if selectedAppearance == 3 {
            userInterfaceStyle = .light
            Color.customtheme = 3
        }else{
            userInterfaceStyle = .unspecified
            Color.customtheme = 0
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}
