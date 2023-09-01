import Foundation

final class VideoEventViewModel: ObservableObject {

    func update(url: URL?) {
        debugPrint("url: \(url)")
    }
}
