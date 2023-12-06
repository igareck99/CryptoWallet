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
    
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
    
    func previous(item: Element) -> Element? {
        if let index = firstIndex(of: item), index >= 0 {
            return index == 0 ? last : self[index - 1]
        }
        return nil
    }
}

extension Array where Element: Equatable & Hashable {
    var asSet: Set<Element> {
        Set(self)
    }
}

extension Array {
	subscript (safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
