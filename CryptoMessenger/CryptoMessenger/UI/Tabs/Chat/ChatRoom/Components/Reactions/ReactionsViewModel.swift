import Combine
import Foundation
import SwiftUI

// MARK: - ReactionsViewModel

final class ReactionsViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var people: [ReactionUser] = [ReactionUser(name: "Кирилл П.",
                                                    avatar: R.image.chat.mockFeed2.image )]
    @Published var reactions: [String: Int]
    @Published var activeEditMessage: RoomMessage?
    var reactionsKeys: [String] = []
    var reactionsValues: [Int] = []
    let resoures: ReactionsViewResourcable.Type

    // MARK: - Lifecycle

    init(
        activeEditMessage: RoomMessage?,
        resoures: ReactionsViewResourcable.Type = ReactionViewResources.self
    ) {
        self.resoures = resoures
        self.activeEditMessage = activeEditMessage
        self.reactions = ["😘": 1, "👎": 3]
        getDict()
    }

    private func getDict() {
        self.reactionsKeys = reactions.map { $0.key }
        self.reactionsValues = reactions.map { $0.value }
    }
}

// MARK: - ReactionUser

struct ReactionUser: Identifiable {

    let id = UUID().uuidString
    let name: String
    let avatar: Image

}
