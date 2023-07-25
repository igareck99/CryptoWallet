import SwiftUI

// MARK: - ChannelDocumentView

struct ChannelDocumentView: View {

    // MARK: - Internal Properties

    @Binding var showFile: Bool
    @Binding var selectedFile: FileData
    @State private var date: String = ""
    var file: FileData
    @StateObject var viewModel: FileViewModel

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            Image(uiImage: viewModel.fileImage)
                .resizable()
                .frame(width: 48, height: 48)
                .cornerRadius(radius: 8, corners: .allCorners)
            VStack(alignment: .leading, spacing: 2) {
                Text(file.fileName)
                    .font(.system(size: 16, weight: .regular))
                HStack(alignment: .center, spacing: 3) {
                    R.image.mediaChatData.downBlueArrow.image
                    Text(viewModel.sizeOfFile + ", " + viewModel.date)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.romanSilver)
                }
            }
            Spacer()
        }
        .background(.white)
        .onTapGesture {
            selectedFile = file
            showFile = true
        }
    }
}
