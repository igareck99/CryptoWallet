import SwiftUI

// MARK: - TextFieldView

struct TextFieldView: View {

    // MARK: - Internal Properties

    var title = ""
    @Binding var text: String
    var placeholder: String
    var color: Palette = .paleBlue()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title, [
                    .font(.semibold(12)),
                    .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left)),
                    .color(.gray768286())

                ])
                .frame(height: 22)
            }
            HStack {
                TextField(placeholder, text: $text)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .foreground(.black())
                    .frame(height: 44)
                    .font(.regular(15))
                    .background(
                        color.suColor
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
            }
        }
    }
}
