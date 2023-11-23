import Foundation

// MARK: - CustomEvent

protocol CustomEvent {

    // MARK: - Internal Methods

    func encodeContent() -> [String: Any]
}
