import SwiftUI

// MARK: - NotesView

struct NotesView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                R.image.buyCellsMenu.close.image
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
                Text(R.string.localizable.noteViewAddNote())
                    .font(.subheadlineMedium15)
                    .foregroundColor(.chineseBlack)
                Spacer()
                Circle()
                    .frame(width: 32, height: 32)
                    .foreground(.white)
            }
            .padding(.horizontal, 16)
            textInput
                .padding(.top, 32)
            info
                .padding(.horizontal, 16)
            importButton
                .padding(.bottom, 8)
                .padding(.top, 48)
        }
    }

    private var textInput: some View {
        TextEditorWithPlaceholder(text: $viewModel.newKey,
                                  placeholder: R.string.localizable.noteViewPlaceholder())
            .frame(width: UIScreen.main.bounds.width - 32,
                   height: 132)
            .padding(.horizontal, 16)
            .onChange(of: viewModel.newKey) { value in
                if value.count > 160 {
                    viewModel.newKey = String(viewModel.newKey.prefix(160))
                }
            }
    }

    private var info: some View {
        HStack {
            Text(R.string.localizable.noteViewWhoSee())
                .font(.caption1Regular12)
                .foregroundColor(.romanSilver)
            Spacer()
            Text("\(viewModel.newKey.count)/160")
                .font(.caption1Regular12)
                .foregroundColor(.romanSilver)
        }
    }

    private var importButton: some View {
        Button {
            viewModel.setUserNote()
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text(R.string.localizable.noteViewApprove())
                .font(.subheadlineMedium15)
                .foregroundColor(viewModel.buttonState ? .romanSilver : .white)
                .frame(width: 185,
                       height: 44)
                .frame(minWidth: 185,
                       idealWidth: 185,
                       maxWidth: 185,
                       minHeight: 44,
                       idealHeight: 44,
                       maxHeight: 44)
                .background(viewModel.buttonState ? Color.lightGrayApprox : Color.dodgerBlue )
                .cornerRadius(8)
        }
        .disabled(viewModel.buttonState)
    }
}
