import SwiftUI

// MARK: - ReserveCopyView

struct ReserveCopyPhraseView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ReservePhraseCopyViewModel

    // MARK: - Body

    var body: some View {
        watchKeyView
            .onAppear {
                viewModel.send(.onAppear)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.sources.reserveCopy)
                        .font(.bold(15))
                }
            }
            .popup(
                isPresented: viewModel.isSnackbarPresented,
                alignment: .bottom
            ) { Snackbar(
                text: viewModel.sources.generatePhraseCopied,
                color: .green
            )
            }
    }

    private var watchKeyView: some View {
        VStack(alignment: .center) {
            Text(viewModel.sources.phraseManagerYourSecretPhrase)
                .font(.regular(22))
                .padding(.top, 59)
            Text(viewModel.sources.generatePhraseGeneratedDescription)
                .font(.regular(15))
                .lineLimit(2)
                .foreground(.darkGray())
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 12)
            textView
                .padding(.top, 24)
            copyKeyButton
                .padding(.top, 84)
            Spacer()
        }
    }

    private var copyKeyButton: some View {
        Button {
            viewModel.onPhraseCopy()
        } label: {
            Text(viewModel.sources.generatePhraseCopyPhrase)
                .foreground(.white())
                .font(.bold(17))
        }
        .frame(width: 237, height: 48)
        .background(Color.azureRadianceApprox)
        .cornerRadius(10)
    }

    private var textView: some View {
        ZStack(alignment: .topLeading) {
        TextEditor(text: $viewModel.generatedKey)
            .padding(.leading, 16)
            .background(.paleBlue())
            .foreground(.black())
            .font(.regular(15))
            .frame(width: UIScreen.main.bounds.width - 32,
                   height: 160)
            .cornerRadius(8)
            .disabled(true)
            .scrollContentBackground(.hidden)
        }
    }
}
