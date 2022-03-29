import SwiftUI

// MARK: - PhraseWarningView

struct PhraseWarningView: View {
    
    // MARK: - Internal Properties

    @Binding var showWarningAlert: Bool
    @Binding var repeatPhrase: Bool
    @Binding var animationOpacity: Double
    @StateObject var viewModel: PhraseManagerViewModel

    // MARK: - Body

    var body: some View {
        content
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .center, spacing: 16) {
            R.image.keyManager.warning.image
                .padding(.top, 48)
            Text(R.string.localizable.phraseManagerWarning())
                .font(.semibold(21))
            Text(R.string.localizable.phraseManagerWarningText())
                .font(.regular(15))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            savedButton
                .frame(width: 241, height: 44)
                .padding(.top, 70)
            Text(R.string.localizable.phraseManagerGoBack())
                .foreground(.blue())
                .padding(.top, 5)
                .onTapGesture {
                    showWarningAlert = false
                }
            Spacer()
        }
    }

    private var savedButton: some View {
        Button {
            showWarningAlert = false
            withAnimation(.easeInOut(duration: 0.5), {
                self.animationOpacity = 0
            })
            withAnimation(.easeInOut(duration: 1), {
                self.animationOpacity = 1
            })
            viewModel.updateStepText()
            repeatPhrase = true
        } label: {
            Text(R.string.localizable.phraseManagerYesiWrite())
                .font(.semibold(15))
                .foreground(.white())
                .frame(width: 179,
                       height: 44)
        }
        .frame(minWidth: 241,
               idealWidth: 241,
               maxWidth: 241,
               minHeight: 44,
               idealHeight: 44,
               maxHeight: 44)
        .background(.blue())
        .cornerRadius(8)
    }
}
