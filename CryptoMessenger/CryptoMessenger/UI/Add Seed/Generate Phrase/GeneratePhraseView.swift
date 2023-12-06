import SwiftUI

// MARK: - GeneratePhraseView

struct GeneratePhraseView<ViewModel: GeneratePhraseViewModelProtocol>: View {

    // MARK: - Internal Methods

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                generateView
            }.popup(
                isPresented: viewModel.isSnackbarPresented,
                alignment: .bottom
            ) {
                Snackbar(
                    text: viewModel.resources.generatePhraseCopied,
                    color: viewModel.resources.snackbarBackground
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
    }

    private var generateView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(viewModel.resources.secretPhraseDescription)
                .font(.subheadlineRegular15)
                .foregroundColor(viewModel.resources.textColor)
                .multilineTextAlignment(.center)
                .frame(minHeight: 60)
                .padding(.horizontal, 18)
                .padding(.top, 24)

            viewModel.resources.puzzle
                .padding(.top, 32)
                .foregroundColor(viewModel.resources.buttonBackground)
                .frame(alignment: .center)
                .scaledToFill()
                .padding(.horizontal, 2)

            createKeyButton
                .padding(.top, 60)

            importKeyButton
                .padding(.top, 21)
                .padding(.bottom, 48)
            Spacer()
        }
    }

    private var importKeyButton: some View {
        Button {
            viewModel.onImportKeyTap()
        } label: {
            Text(viewModel.resources.generatePhraseImportKey)
                .frame(width: 237)
                .font(.bodySemibold17)
                .padding()
                .foregroundColor(viewModel.resources.buttonBackground)
        }
    }

    private var createKeyButton: some View {
        Button {
            viewModel.onCreateKeyTap()
        } label: {
            switch viewModel.isAnimated {
            case false:
                Text(viewModel.resources.keyGenerationCreateButton)
                .foregroundColor(viewModel.resources.background)
                .frame(width: 237)
                .font(.bodySemibold17)
                .padding()
            case true:
                ProgressView()
                    .tint(viewModel.resources.background)
                    .frame(width: 12, height: 12)
            }
        }
        .frame(width: 237, height: 48)
        .background(viewModel.resources.buttonBackground)
        .cornerRadius(8)
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.generatePhraseSecretPhraseTitle)
                .font(.headline2Semibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }
        if viewModel.isBackButtonHidden == false {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text(viewModel.resources.backButtonImage)
                            .font(.bodyRegular17)
                            .foregroundColor(viewModel.resources.titleColor)
                    }
                )
            }
        }
    }
}
