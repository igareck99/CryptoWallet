import SwiftUI

// MARK: - ActionSheetView

struct ActionSheetView: View {

    // MARK: - Internal Properties

    @Binding var showActionSheet: Bool
    @Binding var attachAction: AttachAction?
    @Binding var sendPhotos: Bool
    @Binding var imagesToSend: [UIImage]
    var onCamera: VoidBlock?
    @StateObject var viewModel: AttachActionViewModel

    // MARK: - Private Properties

    @State private var isShown = false
    private let actions: [ActionItem] = AttachAction.allCases.map { .init(action: $0) }

    // MARK: - Body

    var body: some View {
        content
        .onAppear {
            sendPhotos = false
            withAnimation(.easeIn(duration: 0.15).delay(0.2)) {
                isShown.toggle()
            }
        }
        .onTapGesture {
            showActionSheet.toggle()
        }
    }

    private var content: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                VStack {
                    mediaFeedView
                    ForEach(viewModel.actions, id: \.id) { item in
                        cellAction(item: item)
                    }
                }
                .background(.white)
                .cornerRadius(14)

                Button(R.string.localizable.photoEditorAlertCancel()) {
                    vibrate(.soft)
                    showActionSheet.toggle()
                }
                .font(.bodyRegular17)
                .foregroundColor(.spanishCrimson)
                .frame(maxWidth: .infinity, idealHeight: 60, maxHeight: 60)
                .background(.white)
                .cornerRadius(14)
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 10)
        }
        .background(isShown ? Color.chineseBlack04 : .clear)
        .ignoresSafeArea()
    }

    private var balanceView: some View {
        HStack(spacing: 8) {
            Image(R.image.chat.logo.name)
                .resizable()
                .frame(width: 24, height: 24)

            Text("0.50 AUR")
                .font(.bodyRegular17)
                .foregroundColor(.chineseBlack)

            Spacer()
            Text(R.string.localizable.actionSheetSendFoto())
                .font(.bodySemibold17)
                .foregroundColor(.dodgerBlue)
                .opacity(imagesToSend.isEmpty ? 0 : 1)
                .onTapGesture {
                    vibrate(.soft)
                    sendPhotos = true
                    showActionSheet.toggle()
                }
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
        .padding([.leading, .trailing], 16)
    }

    private var mediaFeedView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ZStack {
                    CodeScannerView(codeTypes: []) { _ in }
                    .frame(width: 90, height: 90)
                    .cornerRadius(8)

                    ZStack(alignment: .center) {
                        Image(R.image.chat.camera.name)
                    }
                }
                .frame(width: 90, height: 90)
                .onTapGesture {
                    onCamera?()
                }
                ForEach(viewModel.images, id: \.self) { item in
                    ZStack {
                        Image(uiImage: item)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipped()
                        ZStack(alignment: .top) {
                            VStack {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        R.image.chat.uncheck.image
                                        R.image.chat.group.check.image
                                            .opacity(checkImage(image: item) ? 1 : 0)
                                    }
                                }
                                .padding([.top, .trailing], 8)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: 90, height: 90)
                    .onTapGesture {
                        addPhotosToSend(image: item)
                    }
                }
            }
        }
        .frame(height: 90)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private func cellAction(item: ActionItem) -> some View {
        return Button(action: {
            vibrate()
            attachAction = item.action
            showActionSheet.toggle()
        }, label: {
            HStack(spacing: 16) {
                HStack {
                    item.action.image
                }
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color.dodgerTransBlue)
                .cornerRadius(20)

                Text(item.action.title)
                    .font(.bodyRegular17)
                    .foregroundColor(.dodgerBlue)

                Spacer()
            }
            .background(Color.white)
            .frame(maxWidth: .infinity, idealHeight: 64, maxHeight: 64)
            .padding(.horizontal, 16)
        })
    }

    // MARK: - Internal Methods

    func addPhotosToSend(image: UIImage) {
        if imagesToSend.contains(image) {
            imagesToSend = imagesToSend.filter { $0 != image}
        } else {
            imagesToSend.append(image)
        }
    }

    func checkImage(image: UIImage) -> Bool {
        return imagesToSend.contains(image)
    }
}
