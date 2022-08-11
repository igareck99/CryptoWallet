import SwiftUI

// MARK: - Action

enum AttachAction: CaseIterable, Identifiable {

    // MARK: - Types

    case media
    case document
    case location
    case contact
    case moneyTransfer

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .media:
            return "Фото/ Видео"
        case .document:
            return "Документ"
        case .location:
            return "Геопозиция"
        case .contact:
            return "Контакт"
        case .moneyTransfer:
            return "Перевод средств"
        }
    }

    var image: Image {
        switch self {
        case .media:
            return R.image.chat.action.media.image
        case .document:
            return R.image.chat.action.document.image
        case .location:
            return R.image.chat.action.location.image
        case .contact:
            return R.image.chat.action.contact.image
        case .moneyTransfer:
            return R.image.chat.action.transfer.image
        }
    }
}

// MARK: - ActionSheetView

struct ActionSheetView: View {

    // MARK: - ActionItem

    struct ActionItem: Identifiable {

        // MARK: - Internal Properties

        let id = UUID()
        let action: AttachAction
    }

    // MARK: - Internal Properties

    @Binding var showActionSheet: Bool
    @Binding var attachAction: AttachAction?
    @Binding var cameraFrame: CGImage?
    @Binding var sendPhotos: Bool
    @Binding var imagesToSend: [UIImage]
    var onCamera: VoidBlock?
    var viewModel: AttachActionViewModel

    // MARK: - Private Properties

    @State private var isShown = false
    @State private var isCheck = false
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
                    balanceView
                    mediaFeedView
                    ForEach(actions, id: \.id) { item in
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
                .background(.white())
                .cornerRadius(14)

                Button("Отмена") {
                    vibrate(.soft)
                    showActionSheet.toggle()
                }
                .font(.regular(17))
                .foreground(.red())
                .frame(maxWidth: .infinity, idealHeight: 60, maxHeight: 60)
                .background(.white())
                .cornerRadius(14)
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 10)
        }
        .background(isShown ? .black(0.4) : .clear)
        .ignoresSafeArea()
    }

    private var balanceView: some View {
        HStack(spacing: 8) {
            Image(R.image.chat.logo.name)
                .resizable()
                .frame(width: 24, height: 24)

            Text("0.50 AUR")
                .font(.regular(16))
                .foreground(.black())

            Spacer()
            Text("Отправить Фото")
                .font(.semibold(16))
                .foreground(.blue())
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
                            .frame(width: 90, height: 90)
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
                .background(Color(.blue(0.1)))
                .cornerRadius(20)

                Text(item.action.title)
                    .font(.regular(17))
                    .foreground(.blue())

                Spacer()
            }
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
