import SwiftUI

enum BlockedListAssembly {
    static func build() -> some View {
        let viewModel = BlockListViewModel()
        let view = BlockedUserContentView(viewModel: viewModel)
        return view
    }
}
