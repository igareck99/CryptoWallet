import SwiftUI

// MARK: - DragDelegate

struct DragDelegate<Item: Equatable>: DropDelegate {

    // MARK: - Internal Properties

    @Binding var current: Item?

    // MARK: - Internal Methods

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
    return true
}
}

