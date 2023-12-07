import SwiftUI

final class LoadInfoViewModel: ObservableObject {

    @Published var state: String = "1.25MB/2.8MB"

    func update(url: URL) {
        debugPrint("update(url \(url)")
    }
}
