import SwiftUI

// MARK: - NotesView

struct NotesView: View {

    // MARK: - Internal Properties

    @Binding var showNotes: Bool
    @State private var newKey = ""

    // MARK: - Body

    var body: some View {
        VStack {
            HStack {
                R.image.buyCellsMenu.close.image
                    .onTapGesture {
                        showNotes = false
                    }
                Spacer()
                Text(R.string.localizable.noteViewAddNote())
                    .font(.system(size: 15, weight: .bold))
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 20)
            textInput
            info
            .padding(.horizontal, 16)
            Divider()
                .padding(.top, 48)
            importButton
                .padding([.top, .bottom], 8)
        }
        .onAppear {
            UITextView.appearance().backgroundColor = UIColor.aliceBlue
            UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
        }
    }

    private var textInput: some View {
        ZStack(alignment: .topLeading) {
        TextEditor(text: $newKey)
                .padding(.leading, 16)
                .background(Color.aliceBlue)
                .foregroundColor(.chineseBlack)
                .font(.system(size: 15, weight: .regular))
                .frame(width: UIScreen.main.bounds.width - 32,
                       height: 132)
                .cornerRadius(8)
                .keyboardType(.alphabet)
                .padding(.top, 32)
            if newKey.isEmpty {
                Text(R.string.localizable.noteViewPlaceholder())
                    .foregroundColor(.romanSilver)
                    .padding(.leading, 17)
                    .padding(.top, 12)
                    .disabled(true)
                    .allowsHitTesting(false)
            }
        }
    }

    private var info: some View {
        HStack {
            Text(R.string.localizable.noteViewWhoSee())
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.romanSilver)
            Spacer()
            Text("\(newKey.count)/160")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.romanSilver)
        }
    }

    private var importButton: some View {
        Button {
        } label: {
            Text(R.string.localizable.noteViewApprove())
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(newKey.isEmpty ? .romanSilver : .white)
                .frame(width: 185,
                       height: 44)
                .disabled(newKey.isEmpty)
                .frame(minWidth: 185,
                       idealWidth: 185,
                       maxWidth: 185,
                       minHeight: 44,
                       idealHeight: 44,
                       maxHeight: 44)
                .background(newKey.isEmpty ? Color.ashGray : Color.dodgerBlue )
                .cornerRadius(8)
        }
    }
}
