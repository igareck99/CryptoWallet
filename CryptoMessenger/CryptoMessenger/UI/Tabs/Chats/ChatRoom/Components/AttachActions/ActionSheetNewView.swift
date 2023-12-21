import SwiftUI

// MARK: - ActionSheetNewView

struct ActionSheetNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: AttachActionViewModel

    // MARK: - Private Properties

    @State private var isShown = false
    @State private var images: [UIImage] = []

    // MARK: - Body

    var body: some View {
        content
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(viewModel.computeHeight())])
            .onReceive(viewModel.$images) { value in
                self.images = value
            }
    }

    private var content: some View {
        VStack(spacing: .zero) {
            mediaFeedView
                .padding(.top, 10)
            ForEach(viewModel.actions, id: \.id) { item in
                cellAction(item: item)
            }
        }
        .background(.white)
        .cornerRadius(12)
    }

    private var mediaFeedView: some View {
        HStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ZStack(alignment: .center) {
                        CodeScannerView(codeTypes: []) { _ in }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                        R.image.chat.camera.image
                    }
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        viewModel.onCamera()
                    }
                    ForEach(images, id: \.self) { item in
                        Group {
                            Image(uiImage: item)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .cornerRadius(radius: 10, corners: .allCorners)
                                .onTapGesture {
                                    viewModel.onSendPhoto(item)
                                }
                        }
                    }
                }
            }
        }.frame(height: 98, alignment: .center)
    }

    private func cellAction(item: ActionItem) -> some View {
        return Button(action: {
            vibrate()
            viewModel.didTap(action: item.action)
        }, label: {
            VStack(alignment: .center) {
                HStack(spacing: 8) {
                    item.action.image
                    Text(item.action.title)
                        .font(.calloutRegular16)
                        .foregroundColor(.chineseBlack)
                    Spacer()
                }
                .background(Color.white)
                .frame(maxWidth: .infinity, idealHeight: 57, maxHeight: 57)
                .padding(.horizontal, 16)
            }
        })
    }
}
