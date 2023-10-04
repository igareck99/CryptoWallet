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
        .background(viewModel.resources.background)
    }

    private var centerView: some View {
        VStack(alignment: .center,
               spacing: 8) {
            viewModel.resources.auraLogo
                .resizable()
                .frame(width: 64, height: 64)
            Text(viewModel.resources.nameApp)
                .font(.title2Regular22)
                .foregroundColor(viewModel.resources.titleColor)
            Text(viewModel.appVersion)
                .font(.calloutRegular16)
                .foregroundColor(viewModel.resources.textColor)
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
            Text(viewModel.resources.politicConfidence)
                .font(.calloutRegular16)
                .foregroundColor(viewModel.resources.buttonBackground)
        }
    }
    
    private var usageCondition: some View {
        Button {
            viewModel.onUsageTap()
        } label: {
            Text(viewModel.resources.uasgeConditions)
                .font(.calloutRegular16)
                .foregroundColor(viewModel.resources.buttonBackground)
        }
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.aboutApp)
                .font(.bodySemibold17)
                .lineLimit(1)
        }
    }
}
