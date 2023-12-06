import SwiftUI

struct WatchKeyView<ViewModel: WatchKeyViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Text(viewModel.resources.phraseManagerYourSecretPhrase)
                        .font(.title2Regular22)
                        .padding(.top, 59)

                    Text(viewModel.resources.generatePhraseGeneratedDescription)
                        .font(.subheadlineRegular15)
                        .lineLimit(2)
                        .foregroundColor(viewModel.resources.textColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 295)
                        .padding(.top, 16)

                    textView
                        .padding(.top, 24)

                    copyPhraseButton
                        .padding(.top, 84)

                    Spacer()
                }
            }
            .popup(
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
    }

    private var textView: some View {
        Text(viewModel.generatedKey)
            .font(.bodyRegular17)
            .foregroundColor(viewModel.resources.titleColor)
            .padding(.leading, 16)
            .background(
                viewModel.resources.textBoxBackground
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .frame(height: 160)
    }

    private var copyPhraseButton: some View {
        Button {
            viewModel.onCopyKeyTap()
        } label: {
            Text(viewModel.resources.generatePhraseCopyPhrase)
                .foregroundColor(viewModel.resources.background)
                .frame(width: 237)
                .font(.bodySemibold17)
                .padding()
        }
        .frame(width: 237, height: 48)
        .background(viewModel.resources.buttonBackground)
        .cornerRadius(8)
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        if viewModel.type == .showSeed {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(viewModel.resources.backButtonImage)
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.titleColor)
                }
            }
        }

        ToolbarItem(placement: .principal) {
            Text("Секретная фраза")
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }

        if viewModel.type == .endOfSeedCreation {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.onCloseTap()
                } label: {
                    Text(Image(systemName: "xmark"))
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.titleColor)
                }
            }
        }
    }
}
