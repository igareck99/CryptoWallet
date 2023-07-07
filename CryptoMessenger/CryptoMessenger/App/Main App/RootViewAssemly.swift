import SwiftUI

enum RootViewAssemly {
    static func build() -> some View {
        let viewModel = RootViewModel()
        let rootContent = RootView(viewModel: viewModel)
        return rootContent
    }
}
