import SwiftUI

// MARK: - SocialListAssembly

enum SocialListAssembly {

    // MARK: - Static Methods

    static func build() -> some View {
        let viewModel = SocialListViewModel()
        let view = SocialListView(viewModel: viewModel)
        return view
    }
}
