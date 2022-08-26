import SwiftUI

// MARK: - ChatDocumentView

struct ChatDocumentView: View {

    // MARK: - Internal Properties

    @Binding var showFile: Bool
    @Binding var selectedFile: FileData
    var file: FileData

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(Color(.gray()))
                .frame(width: 48, height: 48)
            VStack(alignment: .leading) {
                Text(file.fileName)
                    .font(.bold(15))
                HStack(alignment: .center, spacing: 4) {
                    R.image.mediaChatData.downBlueArrow.image
                    Text(file.date.description)
                        .font(.bold(15))
                        .foreground(.darkGray())
                }
            }
            Spacer()
        }
        .onTapGesture {
            selectedFile = file
            showFile = true
        }
    }
}
