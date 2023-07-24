import SwiftUI

// MARK: - AboutAppView

struct AboutAppView<ViewModel>: View where ViewModel: AboutAppViewModelDelegate {

    @StateObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            centerView
            Spacer()
            bottomView
                .padding()
        }
        .navigationBarHidden(false)
        .toolbar {
            createToolBar()
        }
        .toolbar(.hidden, for: .tabBar)
        .fullScreenCover(isPresented: viewModel.showWebView) {
            viewModel.safari
        }
        .background(.white)
    }

    private var centerView: some View {
        VStack(alignment: .center,
               spacing: 8) {
            viewModel.sources.auraLogo
                .resizable()
                .frame(width: 64, height: 64)
            Text(viewModel.sources.nameApp)
                .font(.regular(22))
                .foregroundColor(.chineseBlack)
            Text(viewModel.appVersion)
                .font(.regular(16))
                .foregroundColor(.romanSilver)
        }
    }

    private var bottomView: some View {
        VStack(spacing: 10) {
            politicButton
            usageCondition
        }
    }
    
    private var politicButton: some View {
        Button {
            viewModel.onPoliticTap()
        } label: {
            Text(viewModel.sources.politicConfidence)
                .font(.regular(16))
                .foregroundColor(.dodgerBlue)
        }
    }
    
    private var usageCondition: some View {
        Button {
            viewModel.onUsageTap()
        } label: {
            Text(viewModel.sources.uasgeConditions)
                .font(.regular(16))
                .foregroundColor(.dodgerBlue)
        }
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.sources.aboutApp)
                .font(.semibold(17))
                .lineLimit(1)
        }
    }
}
