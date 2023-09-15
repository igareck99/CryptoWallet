import Foundation

enum StaticRoomEventsSizes: CGFloat {
    case audio
    case image
    case map
    
    var size: CGFloat {
        switch self {
        case .audio:
            return 254
        case .image:
            return 208
        case .map:
            return 238
        }
    }
}
