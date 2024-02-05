import SwiftUI

// MARK: - DocumentImageState

enum DocumentImageState {

    case download
    case loading
    case hasBeenDownloaded
    case hasBeenDownloadPhoto

    var image: Image {
        switch self {
        case .download:
            return R.image.chat.chatEventsState.arrowDownGray.image
        case .hasBeenDownloaded:
            return R.image.chat.chatEventsState.paperclip.image
        case .loading:
            return R.image.chat.chatEventsState.stop.image
        default:
            return Image("")
        }
    }
    
    var color: Color {
        switch self {
        case .hasBeenDownloaded:
            return .clear
        default:
            return .chineseBlack04
        }
    }
}

enum DocumentImageStateType {
    
    case file
    case image
}
