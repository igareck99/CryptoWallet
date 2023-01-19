import SwiftUI

// MARK: - GeneratePhraseView

struct GeneratePhraseView: View {

    // MARK: - Internal Methods

    @StateObject var viewModel: GeneratePhraseViewModel
    @Binding var showView: Bool
    let onSelect: GenericBlock<GeneratePhraseState>

    // MARK: - Body

    var body: some View {
        VStack {
            switch viewModel.generatePhraseState {
            case .generate:
                generateView
            case .warning, .importKey:
                warningView
            case .watchKey:
                watchKeyView
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                        UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
                    }
                    .popup(
                        isPresented: viewModel.isSnackbarPresented,
                        alignment: .bottom
                    ) {
                        Snackbar(
                            text: R.string.localizable.generatePhraseCopied(),
                            color: .green
                        )
                    }
            }
        }
        .onChange(of: viewModel.generatePhraseState, perform: { value in
            if value == .importKey {
                onSelect(.importKey)
            }
        })
    }

    private var generateView: some View {
        VStack(alignment: .center) {
            Text(R.string.localizable.generatePhraseTitle())
                .font(.regular(22))
                .padding(.top, 47)
            Text(R.string.localizable.generatePhraseDescription())
                .font(.regular(15))
                .foreground(.darkGray())
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 12)
            Button(R.string.localizable.generatePhraseQuestion()) {
                print("generatePhraseQuestion")
            }
            .padding(.top, 54)
            R.image.generatePhrase.puzzle.image
                .padding(.top, 54)
                .foreground(.blue())
                .frame(minWidth: 0, maxWidth: 254,
                       minHeight: 0, maxHeight: 298, alignment: .center)
                .scaledToFill()
            createKeyButton
                .padding(.top, 60)
            importKeyButton
                .padding(.top, 21)
            Spacer()
        }
    }

    private var warningView: some View {
        VStack(alignment: .center) {
            Text(R.string.localizable.generatePhraseWarning())
                .font(.regular(22))
                .padding(.top, 47)
            Text(R.string.localizable.generatePhraseWarningDescription())
                .font(.regular(15))
                .foreground(.darkGray())
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 12)
            R.image.generatePhrase.person.image
                .padding(.top, 27)
                .foreground(.blue())
                .frame(minWidth: 0, maxWidth: 264,
                       minHeight: 0, maxHeight: 372, alignment: .center)
                .scaledToFill()
            createKeyButton
                .padding(.top, 53)
            importKeyButton
                .padding(.top, 21)
            Spacer()
        }
    }

    private var importKeyButton: some View {
        Button(R.string.localizable.generatePhraseImportKey()) {
            viewModel.toggleState(.importing)
        }
    }

    private var createKeyButton: some View {
        Button {
            if viewModel.generatePhraseState == .watchKey {
                UIPasteboard.general.string = viewModel.generatedKey
                viewModel.onPhraseCopy()
            }
            viewModel.toggleState(.create)
        } label: {
            switch viewModel.isAnimated {
            case false:
                Text(viewModel.generatePhraseState == .watchKey ?
                     R.string.localizable.generatePhraseCopyPhrase() :
                        R.string.localizable.keyGenerationCreateButton())
                    .frame(width: 237)
                    .font(.semibold(14))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            case true:
                ProgressView()
                    .tint(Color(.white()))
                    .frame(width: 12,
                           height: 12)
            }
        }
        .frame(width: 237, height: 48)
        .background(Color.azureRadianceApprox)
        .cornerRadius(10)
    }

    private var watchKeyView: some View {
        VStack(alignment: .center) {
            Text(R.string.localizable.generatePhraseGeneratedTitle())
                .font(.bold(17))
                .padding(.top, 12)
            Text(R.string.localizable.phraseManagerYourSecretPhrase())
                .font(.regular(22))
                .padding(.top, 59)
            Text(R.string.localizable.generatePhraseGeneratedDescription())
                .font(.regular(15))
                .lineLimit(2)
                .foreground(.darkGray())
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 12)
            textView
                .padding(.top, 24)
            createKeyButton
                .padding(.top, 84)
            Spacer()
        }
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
