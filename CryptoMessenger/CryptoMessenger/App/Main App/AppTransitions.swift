import Foundation

enum AppContentLink: Identifiable, Hashable {

    case call(
        model: P2PCall,
        p2pCallUseCase: P2PCallUseCaseProtocol
    )

    // MARK: - Identifiable

    var id: String {
        String(describing: self)
    }

    // MARK: - Equatable

    static func == (lhs: AppContentLink, rhs: AppContentLink) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
