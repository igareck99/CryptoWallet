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
                Text("Добавить заметку")
                    .font(.bold(15))
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
            UITextView.appearance().backgroundColor = UIColor(.paleBlue())
            UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
        }
    }

    private var textInput: some View {
        ZStack(alignment: .topLeading) {
        TextEditor(text: $newKey)
                .padding(.leading, 16)
                .background(.paleBlue())
                .foreground(.black())
                .font(.regular(15))
                .frame(width: UIScreen.main.bounds.width - 32,
                       height: 132)
                .cornerRadius(8)
                .keyboardType(.alphabet)
                .padding(.top, 32)
            if newKey.isEmpty {
                Text(R.string.localizable.noteViewPlaceholder())
                    .foreground(.darkGray())
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
                .font(.regular(12))
                .foreground(.darkGray())
            Spacer()
            Text("\(newKey.count)/160")
                .font(.regular(12))
                .foreground(.darkGray())
        }
    }

    private var importButton: some View {
        Button {
        } label: {
            Text(R.string.localizable.noteViewApprove())
                .font(.semibold(15))
                .foreground(newKey.isEmpty ? .darkGray() : .white())
                .frame(width: 185,
                       height: 44)
                .disabled(newKey.isEmpty)
                .frame(minWidth: 185,
                       idealWidth: 185,
                       maxWidth: 185,
                       minHeight: 44,
                       idealHeight: 44,
                       maxHeight: 44)
                .background(newKey.isEmpty ? Color(.lightGray()) : Color(.blue()) )
                .cornerRadius(8)
        }
    }
}
