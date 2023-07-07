import SwiftUI

struct RootView<ViewModel: RootViewAppModelable>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        viewModel.rootView.anyView()
    }
}
