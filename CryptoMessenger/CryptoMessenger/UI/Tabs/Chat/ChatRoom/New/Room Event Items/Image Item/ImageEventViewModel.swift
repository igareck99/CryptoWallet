import Foundation

final class ImageEventViewModel: ObservableObject {
    
    func update(url: URL?) {
        debugPrint("url \(url)")
    }
}
