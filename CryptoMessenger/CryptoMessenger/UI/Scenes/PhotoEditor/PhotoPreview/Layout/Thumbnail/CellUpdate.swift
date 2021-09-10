import UIKit

internal func+<T>(lhs: @escaping (T) -> T,
                  rhs: ((T) -> T)?) -> (T) -> T {
    return { lhs(rhs?($0) ?? $0) }
}

// MARK: - ThumbnailLayout ()

extension ThumbnailLayout {

    // MARK: - Type

    typealias CellUpdate = (Cell) -> Cell

    // MARK: - UpdateType

    enum UpdateType {

        // MARK: - Types

        case expand(CGFloat)
        case collapse(CGFloat)
        case delete(CGFloat, Cell.Direction)

        // MARK: - Internal Properties

        var closure: CellUpdate {
            { $0.updated(by: self) }
        }
    }
}

// MARK: - ThumbnailLayout.Cell ()

extension ThumbnailLayout.Cell {
    func updated(by update: ThumbnailLayout.UpdateType) -> ThumbnailLayout.Cell {
        switch update {
        case .collapse(let rate):
            return updated(new: state.collapsed(by: rate))
        case .expand(let rate):
            return updated(new: state.expanded(by: rate))
        case .delete(let rate, let direction):
            return updated(new: state.deleting(by: rate, with: direction))
        }
    }
}

// MARK: - ThumbnailLayout.Cell.State ()

private extension ThumbnailLayout.Cell.State {

    // MARK: - Type

    typealias State = ThumbnailLayout.Cell.State

    func expanded(by rate: CGFloat) -> State {
        return State(
            expanding: rate,
            collapsing: collapsing,
            deleting: deleting,
            deletingDirection: deletingDirection)
    }

    func collapsed(by rate: CGFloat) -> State {
        return State(
            expanding: expanding,
            collapsing: rate,
            deleting: deleting,
            deletingDirection: deletingDirection)
    }

    func deleting(by rate: CGFloat,
                  with direction: ThumbnailLayout.Cell.Direction) -> State {
        return State(
            expanding: expanding,
            collapsing: collapsing,
            deleting: rate,
            deletingDirection: direction)
    }
}
