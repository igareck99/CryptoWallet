import SwiftUI

// MARK: - AboutAppNewView

struct AboutAppNewView<ViewModel>: View where ViewModel: AboutAppViewModelDelegate {

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
        .fullScreenCover(isPresented: viewModel.showWebView) {
            viewModel.safari
        }
    }

    private var centerView: some View {
        VStack(alignment: .center,
               spacing: 8) {
            viewModel.sources.auraLogo
                .resizable()
                .frame(width: 64, height: 64)
            Text(viewModel.sources.nameApp)
                .font(.regular(22))
            Text(viewModel.appVersion)
                .font(.regular(16))
                .foregroundColor(.manatee)
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
                .foregroundColor(.azureRadianceApprox)
        }
    }
    
    private var usageCondition: some View {
        Button {
            viewModel.onUsageTap()
        } label: {
            Text(viewModel.sources.uasgeConditions)
                .font(.regular(16))
                .foregroundColor(.azureRadianceApprox)
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
