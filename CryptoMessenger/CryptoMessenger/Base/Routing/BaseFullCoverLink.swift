import SwiftUI

enum BaseFullCoverLink: Hashable, Identifiable {
    
    // Chat history
    case imageViewer(image: Image?, imageUrl: URL?)
    
    case video(url: URL)
    
    case openOtherApp(
        place: Place,
        showLocationTransition: Binding<Bool>
    )
    
    var id: String {
        String(describing: self)
    }
    
    static func == (lhs: BaseFullCoverLink, rhs: BaseFullCoverLink) -> Bool {
        return rhs.id == lhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

