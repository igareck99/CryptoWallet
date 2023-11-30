import Foundation

protocol PasteboardServiceProtocol {
    func copyToPasteboard(text: String)
}

final class PasteboardService: PasteboardServiceProtocol {
    static let shared = PasteboardService()

    func copyToPasteboard(text: String) {
        UIPasteboard.general.string = text
    }
}
