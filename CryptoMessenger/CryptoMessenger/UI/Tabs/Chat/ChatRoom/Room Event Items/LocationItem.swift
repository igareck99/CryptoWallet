import Foundation
import SwiftUI

struct LocationItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let date: String
    let coordinate: Coordinate
    let reactionItems: [ReactionTextsItem]
    let readStatus: EventStatus
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EmptyView().anyView()
    }
}

struct Coordinate {
    let lattitude: Double
    let longitude: Double
}
