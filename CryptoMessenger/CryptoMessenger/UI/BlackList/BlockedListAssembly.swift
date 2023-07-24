import SwiftUI

// MARK: - BlockedListAssembly

enum BlockedListAssembly {

    // MARK: - Static Methods

    static func build() -> some View {
        let viewModel = BlockListViewModel()
        let view = BlockedUserContentView(viewModel: viewModel)
        return view
    }
}
