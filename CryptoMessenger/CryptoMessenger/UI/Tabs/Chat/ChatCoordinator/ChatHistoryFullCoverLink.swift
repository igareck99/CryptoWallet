import SwiftUI

enum ChatHistoryFullCoverLink: Hashable, Identifiable {

    case imageViewer(imageUrl: URL?)

    case video(url: URL)

    case openOtherApp(
        place: Place,
        showLocationTransition: Binding<Bool>
    )

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ChatHistoryFullCoverLink, rhs: ChatHistoryFullCoverLink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
