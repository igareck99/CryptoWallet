import Foundation

// MARK: - ChannelMediaTabs

enum ChannelMediaTabs: CaseIterable, Identifiable {

    // MARK: - Types

    case media, links, documents

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .media:
            return "Медиа"
        case .links:
            return "Ссылки"
        case .documents:
            return "Документы"
        }
    }
}
