import SwiftUI

// MARK: - ActionSheetNewView

struct ActionSheetNewView: View {

    // MARK: - Internal Properties

    var viewModel: AttachActionViewModel

    // MARK: - Private Properties

    @State private var isShown = false
    @State private var images: [UIImage] = []

    // MARK: - Body

    var body: some View {
        content
            .onReceive(viewModel.$images) { value in
                self.images = value
            }
    }

    private var content: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                VStack {
                    mediaFeedView
                    ForEach(viewModel.actions, id: \.id) { item in
                        if item.action == .moneyTransfer {
                            if viewModel.isTransactionAvailable {
                                cellAction(item: item)
                            } else {
                                EmptyView()
                            }
                        } else {
                            cellAction(item: item)
                        }
                    }
                }
                .background(.white)
                .cornerRadius(14)
            }
        }
    }

    private var mediaFeedView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ZStack {
                    CodeScannerView(codeTypes: []) { _ in }
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)

                    ZStack(alignment: .center) {
                        Image(R.image.chat.camera.name)
                    }
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
        .frame(height: 80)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private func cellAction(item: ActionItem) -> some View {
        return Button(action: {
            vibrate()
            viewModel.tappedAction(item.action)
        }, label: {
            HStack(spacing: 16) {
                HStack {
                    item.action.image
                }
                .cornerRadius(20)
                Text(item.action.title)
                    .font(.calloutRegular16)
                    .foregroundColor(.chineseBlack)
                Spacer()
            }
            .background(Color.white)
            .frame(height: 57)
            .padding(.horizontal, 16)
        })
    }
}
