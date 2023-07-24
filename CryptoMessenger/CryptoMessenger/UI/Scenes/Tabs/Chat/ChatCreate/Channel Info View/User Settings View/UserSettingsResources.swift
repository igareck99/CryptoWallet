import SwiftUI
import Foundation

protocol UserSettingsResourcable {
    static var rectangleColor: Color { get }
}

enum UserSettingsResources: UserSettingsResourcable {
    static var rectangleColor: Color {
        .gainsboro
    }
}
