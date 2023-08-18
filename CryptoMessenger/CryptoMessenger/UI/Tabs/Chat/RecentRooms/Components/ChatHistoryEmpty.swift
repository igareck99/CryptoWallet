import SwiftUI

// MARK: - ChatHistoryEmpty

enum ChatHistoryEmpty {

    case noData
    case emptySearch

    var image: Image {
        switch self {
        case .noData:
           return R.image.chatHistory.nodata.image
        case .emptySearch:
            return R.image.chatHistory.emptyState.image
        }
    }

    var title: String {
        switch self {
        case .noData:
            return R.string.localizable.chatHistoryNoResult()
        case .emptySearch:
            return R.string.localizable.chatHistorySearchEmpty()
        }
    }

    var description: String {
        switch self {
        case .noData:
            return R.string.localizable.chatHistoryNothingFind()
        case .emptySearch:
            return R.string.localizable.chatHistoryEnterData()
        }
    }
}
