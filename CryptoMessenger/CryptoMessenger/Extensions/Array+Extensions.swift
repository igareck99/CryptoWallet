import Foundation

// MARK: - Array (Equatable)

extension Array where Element: Equatable {

    // MARK: - Internal Properties

    func next(item: Element) -> Element? {
        if let index = firstIndex(of: item), index + 1 <= count {
            return index + 1 == count ? self[0] : self[index + 1]
        }
        return nil
    }

    func previous(item: Element) -> Element? {
        if let index = firstIndex(of: item), index >= 0 {
            return index == 0 ? last : self[index - 1]
        }
        return nil
    }
}
