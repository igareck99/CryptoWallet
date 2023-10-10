import SwiftUI

// MARK: - AudioEventItemState

enum AudioEventItemState {
    case download
    case loading
    case play
    case stop
    
    var image: Image {
        switch self {
        case .download:
            return R.image.chat.chatEventsState.arrowDownGray.image
        case .play:
            return R.image.chat.chatEventsState.playFill.image
        case .loading:
            return R.image.chat.chatEventsState.stop.image
        case .stop:
            return R.image.chat.chatEventsState.pauseFill.image
        }
    }
}
