import SwiftUI

enum AddSeedSheetLink: Identifiable, Hashable {

    var id: String {
        String(describing: self)
    }

    static func == (lhs: AddSeedSheetLink, rhs: AddSeedSheetLink) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum AddSeedContentLink: Identifiable, Hashable {

    case importKey(coordinator: ImportKeyCoordinatable)

    // MARK: - Identifiable

    var id: String {
        String(describing: self)
    }

    // MARK: - Equatable

    static func == (lhs: AddSeedContentLink, rhs: AddSeedContentLink) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
