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

    // MARK: - Internal Properties

    @Binding var showActionSheet: Bool
    @Binding var attachAction: AttachAction?

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()

                VStack {
                    balanceView

                    mediaFeedView

                    ForEach(AttachAction.allCases, id: \.id) { act in
                        Button(action: {
                            vibrate()
                            attachAction = act
                            showActionSheet.toggle()
                        }, label: {
                            HStack(spacing: 16) {
                                HStack {
                                    act.image
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(Color(.blue(0.1)))
                                .cornerRadius(20)

                                Text(act.title)
                                    .font(.regular(17))
                                    .foreground(.blue())

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, idealHeight: 64, maxHeight: 64)
                            .padding([.leading, .trailing], 16)
                        })
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
            .padding(.bottom, 34)
        }
        .background(isShown ? .black(0.4) : .clear)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeIn(duration: 0.15).delay(0.2)) {
                isShown.toggle()
            }
        }
        .onTapGesture {
            showActionSheet.toggle()
        }
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
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
        .padding([.leading, .trailing], 16)
    }

    private var mediaFeedView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ZStack {
                    Image(R.image.chat.mockFeed1.name)
                        .resizable()
                        .frame(width: 90, height: 90)

                    ZStack(alignment: .center) {
                        Image(R.image.chat.camera.name)
                    }
                }
                .frame(width: 90, height: 90)

                ZStack {
                    Image(R.image.chat.mockFeed2.name)
                        .resizable()
                        .frame(width: 90, height: 90)

                    ZStack(alignment: .top) {
                        VStack {
                            HStack {
                                Spacer()
                                Image(R.image.chat.uncheck.name)
                            }
                            .padding([.top, .trailing], 8)

                            Spacer()
                        }
                    }
                }
                .frame(width: 90, height: 90)

                ZStack {
                    Image(R.image.chat.mockFeed3.name)
                        .resizable()
                        .frame(width: 90, height: 90)

                    ZStack(alignment: .top) {
                        VStack {
                            HStack {
                                Spacer()
                                Image(R.image.chat.uncheck.name)
                            }
                            .padding([.top, .trailing], 8)

                            Spacer()
                        }
                    }
                }
                .frame(width: 90, height: 90)

                ZStack {
                    Image(R.image.chat.mockFeed3.name)
                        .resizable()
                        .frame(width: 90, height: 90)

                    ZStack(alignment: .top) {
                        VStack {
                            HStack {
                                Spacer()
                                Image(R.image.chat.uncheck.name)
                            }
                            .padding([.top, .trailing], 8)

                            Spacer()
                        }
                    }
                }
                .frame(width: 90, height: 90)

                ZStack {
                    Image(R.image.chat.mockFeed2.name)
                        .resizable()
                        .frame(width: 90, height: 90)

                    ZStack(alignment: .top) {
                        VStack {
                            HStack {
                                Spacer()
                                Image(R.image.chat.uncheck.name)
                            }
                            .padding([.top, .trailing], 8)

                            Spacer()
                        }
                    }
                }
                .frame(width: 90, height: 90)
            }
        }
        .frame(height: 90)
        .padding([.leading, .trailing], 16)
        .padding(.bottom, 8)
    }
}
