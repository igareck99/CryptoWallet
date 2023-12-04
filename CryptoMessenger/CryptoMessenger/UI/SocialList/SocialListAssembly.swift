import SwiftUI

enum SocialListAssembly {
    static func build() -> some View {
        let viewModel = SocialListViewModel()
        let view = SocialListView(viewModel: viewModel)
        return view
    }
}
