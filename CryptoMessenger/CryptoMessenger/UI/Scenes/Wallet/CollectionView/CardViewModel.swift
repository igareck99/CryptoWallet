import Foundation

// MARK: - CardViewModel

struct CardViewModel {

    // MARK: - Type

    typealias ItemType = Card

    // MARK: - Internal Properties

    let items: [ItemType]

    // MARK: - Lifecycle

    init(_ items: [ItemType]) {
        self.items = items
    }

    // MARK: - Constants

    enum Constants {
        static let rowHeight = Float(193)
        static let rowWidth = Float(343)
    }
}

// MARK: - OccasionViewModel (CollectionViewProviderViewModel)

extension CardViewModel: CollectionViewProviderViewModel {
    func numberOfItemsIn(section: Int) -> Int { items.count }
}
