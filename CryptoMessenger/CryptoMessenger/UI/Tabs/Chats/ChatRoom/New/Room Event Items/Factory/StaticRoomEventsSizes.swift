import Foundation

enum StaticRoomEventsSizes: CGFloat {
    case audio
    case image
    case map
    case contact
    case document
    
    var size: CGFloat {
        switch self {
        case .audio:
            return 254
        case .image:
            return 208
        case .map:
            return 238
        case .contact:
            return 212
        case .document:
            return 230
        }
    }
}
