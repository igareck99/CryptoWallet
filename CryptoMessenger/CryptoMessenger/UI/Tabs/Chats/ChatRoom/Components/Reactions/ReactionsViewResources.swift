import Foundation
import SwiftUI


protocol ReactionsViewResourcable {
    static var avatarBackground: Color { get }
}


enum ReactionViewResources: ReactionsViewResourcable {
    static var avatarBackground: Color {
        .dodgerTransBlue
    }
}
