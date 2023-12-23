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
    }

    private var mediaFeedView: some View {
        VStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ZStack(alignment: .center) {
                        CodeScannerView(codeTypes: []) { _ in }
                            .frame(width: 80, height: 80)
                            .cornerRadius(radius: 10, corners: .allCorners)
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
        }
        .frame(height: 98, alignment: .center)
        .padding(.leading, 16)
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
                .frame(maxWidth: .infinity, idealHeight: 52, maxHeight: 52)
                .background(Color.white)
                .padding(.leading, 16)
            }
        })
    }
}
