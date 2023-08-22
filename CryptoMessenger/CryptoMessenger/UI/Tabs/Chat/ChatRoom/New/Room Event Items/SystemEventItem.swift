import Foundation
import SwiftUI

struct SystemEventItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let date: String
    let text: String
    let type: SystemEventType
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EmptyView().anyView()
    }
}

enum SystemEventType {
    case date
    case groupCall
}
