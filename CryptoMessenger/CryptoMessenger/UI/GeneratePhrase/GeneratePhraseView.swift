import SwiftUI

// MARK: - GeneratePhraseView

struct GeneratePhraseView: View {

    // MARK: - Internal Methods

    @StateObject var viewModel: GeneratePhraseViewModel
    let onSelect: GenericBlock<GeneratePhraseState>
    let onCreate: VoidBlock

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
        .onChange(of: viewModel.generatePhraseState, perform: { newValue in
            if newValue == .watchKey {
                onCreate()
            }
        })
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

    private var generateView: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.resources.generatePhraseTitle)
                .font(.system(size: 22, weight: .regular))
                .padding(.top, 47)
           
            Text(viewModel.resources.generatePhraseDescription)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(viewModel.resources.textColor)
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .frame(minHeight: 60)
                .padding(.horizontal, 24)
                .padding(.top, 24)
           
            Button {
                debugPrint(viewModel.resources.generatePhraseQuestion)
            } label: {
                Text(viewModel.resources.generatePhraseQuestion)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 15))
                    .padding(.horizontal, 16)
                    .foregroundColor(viewModel.resources.buttonBackground)
            }
            .padding(.vertical, 48)
           
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

    private var warningView: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.resources.generatePhraseWarning)
                .font(.system(size: 22))
                .padding(.top, 47)
            
            Text(viewModel.resources.generatePhraseWarningDescription)
                .font(.system(size: 15))
                .foregroundColor(viewModel.resources.textColor)
                .multilineTextAlignment(.center)
                .frame(width: 295)
                .padding(.top, 12)
            
            viewModel.resources.person
                .padding(.top, 32)
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
            Text(viewModel.resources.generatePhraseImportKey)
                .frame(width: 237)
                .font(.system(size: 17, weight: .semibold))
                .padding()
                .foregroundColor(viewModel.resources.buttonBackground)
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
                     viewModel.resources.generatePhraseCopyPhrase :
                        viewModel.resources.keyGenerationCreateButton)
                .foregroundColor(viewModel.resources.background)
                .frame(width: 237)
                .font(.system(size: 17, weight: .semibold))
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

    private var watchKeyView: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.resources.generatePhraseGeneratedTitle)
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 12)
            
            Text(viewModel.resources.phraseManagerYourSecretPhrase)
                .font(.system(size: 22))
                .padding(.top, 59)
            
            Text(viewModel.resources.generatePhraseGeneratedDescription)
                .font(.system(size: 15))
                .lineLimit(2)
                .foregroundColor(viewModel.resources.textColor)
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
            .background(viewModel.resources.textBoxBackground
                    .cornerRadius(8)
                    .frame(minHeight: 160)
            )
            .foregroundColor(viewModel.resources.titleColor)
            .font(.system(size: 17))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .frame(height: 160)
            .disabled(true)
            .scrollContentBackground(.hidden)
    }
}
