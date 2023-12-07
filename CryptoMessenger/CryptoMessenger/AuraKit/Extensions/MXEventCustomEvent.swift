import Foundation

enum MXEventCustomEvent {
    
    case contactInfo
    case cryptoSend

    var identifier: String {
        switch self {
        case .contactInfo:
            return "ms.aura.contact"
        case .cryptoSend:
            return "ms.aura.pay"
        }
    }
}
