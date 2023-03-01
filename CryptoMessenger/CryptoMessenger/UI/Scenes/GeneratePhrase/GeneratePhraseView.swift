import SwiftUI

// MARK: - GeneratePhraseView

struct GeneratePhraseView: View {

    // MARK: - Internal Methods

    @StateObject var viewModel: GeneratePhraseViewModel
    @Binding var showView: Bool
    let onSelect: GenericBlock<GeneratePhraseState>

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
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
                }
            }
            .onChange(of: viewModel.generatePhraseState, perform: { value in
                if value == .importKey {
                    onSelect(.importKey)
                }
            })
        }
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: viewModel.sources.generatePhraseCopied,
                color: .green
            )
        }
    }

    private var generateView: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.sources.generatePhraseTitle)
                .font(.regular(22))
                .padding(.top, 47)
           
            Text(viewModel.sources.generatePhraseDescription)
                .font(.regular(15))
                .foreground(.darkGray())
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .frame(minHeight: 60)
                .padding(.horizontal, 24)
                .padding(.top, 24)
           
            Button {
                debugPrint("generatePhraseQuestion")
            } label: {
                Text(R.string.localizable.generatePhraseQuestion())
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 15))
                    .padding(.horizontal, 16)
                    .foregroundColor(.azureRadianceApprox)
            }
            .padding(.vertical, 48)
           
            viewModel.sources.puzzle
                .padding(.top, 32)
                .foreground(.blue())
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

    private var warningView: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.sources.generatePhraseWarning)
                .font(.system(size: 22))
                .padding(.top, 47)
            
            Text(viewModel.sources.generatePhraseWarningDescription)
                .font(.system(size: 15))
                .foreground(.darkGray())
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 12)
            
            viewModel.sources.person
                .padding(.top, 32)
                .foreground(.blue())
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
            viewModel.toggleState(.importing)
        } label: {
            Text(viewModel.sources.generatePhraseImportKey)
                .frame(width: 237)
                .font(.system(size: 17, weight: .semibold))
                .padding()
                .foregroundColor(.azureRadianceApprox)
        }
    }

    private var createKeyButton: some View {
        Button {
            if (viewModel.generatePhraseState == .watchKey ||
                viewModel.generatePhraseState == .generate) &&
                viewModel.generatedKey.isEmpty == false {
                UIPasteboard.general.string = viewModel.generatedKey
                viewModel.onPhraseCopy()
            }
            viewModel.toggleState(.create)
        } label: {
            switch viewModel.isAnimated {
            case false:
                Text(viewModel.generatePhraseState == .watchKey ?
                     viewModel.sources.generatePhraseCopyPhrase :
                        viewModel.sources.keyGenerationCreateButton)
                .foregroundColor(.white)
                .frame(width: 237)
                .font(.system(size: 17, weight: .semibold))
                .padding()
            case true:
                ProgressView()
                    .tint(Color(.white()))
                    .frame(width: 12, height: 12)
            }
        }
        .frame(width: 237, height: 48)
        .background(Color.azureRadianceApprox)
        .cornerRadius(8)
    }

    private var watchKeyView: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.sources.generatePhraseGeneratedTitle)
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 12)
            
            Text(viewModel.sources.phraseManagerYourSecretPhrase)
                .font(.system(size: 22))
                .padding(.top, 59)
            
            Text(viewModel.sources.generatePhraseGeneratedDescription)
                .font(.system(size: 15))
                .lineLimit(2)
                .foreground(.darkGray())
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 16)
            
            textView
                .padding(.top, 24)
            
            createKeyButton
                .padding(.top, 84)
            
            Spacer()
        }
    }

    private var textView: some View {
        TextEditor(text: $viewModel.generatedKey)
            .cornerRadius(8)
            .padding(.leading, 16)
            .background(
                Color
                    .polarApprox
                    .cornerRadius(8)
                    .frame(minHeight: 160)
            )
            .foreground(.black())
            .font(.system(size: 17))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .frame(height: 160)
            .disabled(true)
            .scrollContentBackground(.hidden)
    }
}
