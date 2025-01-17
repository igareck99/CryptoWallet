import SwiftUI

// MARK: - PhraseManagerView

struct PhraseManagerView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PhraseManagerViewModel
    @State var showWarningAlert = false
    @State var unLockPhrase = false
    @State var repeatPhrase = false
    @State var wrongRepeatPhrase = true
    @State var animationOpacity: Double = 1
    @State var showSuccessAlert = false
    @State var textEditorDisabled = true
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
                UITextView.appearance().backgroundColor = .clear
                UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
            }
            .onChange(of: viewModel.secretPhraseForApprove, perform: { newValue in
                if newValue == viewModel.secretPhrase {
                    wrongRepeatPhrase = false
                } else {
                    wrongRepeatPhrase = true
                }
            })
            .alert(isPresented: $showSuccessAlert) { () -> Alert in
                let dismissButton = Alert.Button.default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
                let alert = Alert(title: Text(viewModel.sources.phraseManagerSuccessPhrase),
                                  message: Text(""),
                                  dismissButton: dismissButton)
                return alert
            }
            .popup(isPresented: $showWarningAlert,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: Color(.black(0.3)),
                   view: {
                PhraseWarningView(showWarningAlert: $showWarningAlert,
                                  repeatPhrase: $repeatPhrase,
                                  animationOpacity: $animationOpacity,
                                  viewModel: viewModel)
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height / 2 + 20,
                           alignment: .center)
                    .background(.white())
                    .cornerRadius(16)
            }
            )
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.sources.chatSettingsReserveCopy)
                        .font(.system(size: 15, weight: .bold))
                }
            }
    }

    // MARK: - Private Properties

    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center) {
                Divider()
                    .padding(.top, 16)
                VStack(spacing: 40) {
                    Text(viewModel.stepText)
                        .font(.system(size: 15))
                        .opacity(animationOpacity)
                    Text(viewModel.title)
                        .font(.system(size: 21, weight: .semibold))
                        .opacity(animationOpacity)
                }
                .padding(.top, 40)
                Text(!unLockPhrase ? viewModel.description : (!repeatPhrase ?
                                                              viewModel.sources.phraseManagerWriteAndRemember :
                                                                viewModel.sources.phraseManagerLetsCheck))
                .font(.system(size: 15))
                .frame(height: 80)
                .multilineTextAlignment(.center)
                .opacity(animationOpacity)
                .padding(.top, 16)
                .padding(.horizontal, 24)
                ZStack {
                    TextEditor(text: repeatPhrase ? $viewModel.secretPhraseForApprove : $viewModel.secretPhrase)
                        .blur(radius: !unLockPhrase ? 10 : 0)
                        .padding(.leading, 16)
                        .background(repeatPhrase && wrongRepeatPhrase ? .lightRed(0.1) : .paleBlue())
                        .foreground(.black())
                        .font(.regular(15))
                        .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                        .cornerRadius(8)
                        .disabled(viewModel.textEditorDisabled)
						.scrollContentBackground(.hidden)
                    if !unLockPhrase {
                        HStack(alignment: .center, spacing: 9) {
                            lockView
                                .padding(.horizontal, 32)
                                .padding(.top, 20)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)
                if repeatPhrase {
                    Text(viewModel.sources.phraseManagerWrongOrder)
                        .font(.regular(15))
                        .foreground(.red())
                        .opacity(repeatPhrase && wrongRepeatPhrase ? 1 : 0)
                    Divider()
                        .padding(.top, 91)
                    finishButton
                        .padding(.top, 8)
                        .frame(width: 241, height: 44)
                } else {
                    VStack {
                        Text(viewModel.sources.phraseManagerWhatIsSecretPhrase)
                            .font(.system(size: 15))
                            .foreground(.blue())
                            .padding(.top, 20)
                            .opacity(!repeatPhrase ? 1 : 0)
                        Divider()
                            .padding(.top, 91)
                            .opacity(!repeatPhrase ? 1 : 0)
                        importButton
                            .padding(.top, 8)
                            .frame(width: 241, height: 44)
                            .opacity(!repeatPhrase ? 1 : 0)
                        Text(viewModel.sources.phraseManagerRememberLater)
                            .font(.system(size: 15, weight: .semibold))
                            .foreground(.blue())
                            .padding(.top, 21)
                            .opacity(!repeatPhrase ? 1 : 0)
                    }
                }
                Spacer()
            }
        }
    }

    private var lockView: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 0) {
                viewModel.sources.lock
            }
            HStack(alignment: .center, spacing: 0) {
                Text(viewModel.sources.phraseManagerTapToSee)
                    .font(.system(size: 15))
                    .padding(.horizontal, 32)
                    .multilineTextAlignment(.center)
            }
            watchButton
                .frame(width: 189)
                .padding(.top, 8)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5), {
                self.animationOpacity = 0
            })
            withAnimation(.easeInOut(duration: 1), {
                self.animationOpacity = 1
            })
            viewModel.updateTitleToWriteText()
        }
    }

    private var watchButton: some View {
        Button(action: {
            unLockPhrase = true
        }, label: {
            Text(viewModel.sources.phraseManagerWatch)
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                .font(.system(size: 15, weight: .semibold))
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                        .frame(width: 189, height: 44)
                )
        })
    }

    private var importButton: some View {
        Button {
            showWarningAlert = true
        } label: {
            Text(viewModel.sources.phraseManagerISavePhrase)
                .font(.system(size: 15, weight: .semibold))
                .foreground(!unLockPhrase ? .darkGray() : .white())
                .frame(width: 179, height: 44)
        }
        .disabled(!unLockPhrase)
        .frame(minWidth: 241,
               idealWidth: 241,
               maxWidth: 241,
               minHeight: 44,
               idealHeight: 44,
               maxHeight: 44)
        .background(!unLockPhrase ? .lightGray() : .blue() )
        .cornerRadius(8)
    }

    private var finishButton: some View {
        Button {
            showSuccessAlert = true
        } label: {
            Text(viewModel.sources.phraseManagerComplete)
                .font(.semibold(15))
                .foreground(wrongRepeatPhrase ? .darkGray() : .white())
                .frame(width: 179,
                       height: 44)
        }
        .disabled(wrongRepeatPhrase)
        .frame(minWidth: 241,
               idealWidth: 241,
               maxWidth: 241,
               minHeight: 44,
               idealHeight: 44,
               maxHeight: 44)
        .background(wrongRepeatPhrase ? .lightGray() : .blue() )
        .cornerRadius(8)
    }
}
