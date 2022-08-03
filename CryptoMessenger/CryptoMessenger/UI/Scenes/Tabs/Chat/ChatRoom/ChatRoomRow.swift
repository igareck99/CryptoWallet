import MatrixSDK
import SwiftUI

// swiftlint:disable:all

// MARK: - ChatRoomRow

struct ChatRoomRow: View {

    // MARK: - Internal Properties

    @State var chatContactInfo = ChatContactInfo(name: "")
    @Binding var activateShowCard: Bool
    @Binding var playingAudioId: String

    // MARK: - Private Properties

    private let message: RoomMessage
    private let isFromCurrentUser: Bool
    private let isPreviousFromCurrentUser: Bool
    private let isDirect: Bool
    private var onReaction: StringBlock?
    private var onSelectPhoto: GenericBlock<URL?>?
    @StateObject var audioViewModel: AudioMessageViewModel

    @State private var showMap = false
    @State private var showFile = false
    @State private var isAnimating = false
    @State private var showContactInfo = false
    @State private var degress = 0.0

    // MARK: - Lifecycle

    init(
        message: RoomMessage,
        isPreviousFromCurrentUser: Bool,
        isDirect: Bool,
        onReaction: StringBlock?,
        onSelectPhoto: GenericBlock<URL?>?,
        activateShowCard: Binding<Bool>,
        playingAudioId: Binding<String>
    ) {
        self.message = message
        self.isFromCurrentUser = message.isCurrentUser
        self.isPreviousFromCurrentUser = isPreviousFromCurrentUser
        self.isDirect = isDirect
        self.onReaction = onReaction
        self.onSelectPhoto = onSelectPhoto
        self._activateShowCard = activateShowCard
        self._playingAudioId = playingAudioId
        switch message.type {
        case let .audio(url):
            self._audioViewModel = StateObject(wrappedValue: AudioMessageViewModel(url: url,
                                                                                   messageId: message.id))
        default:
            let url = URL(string: "")
            self._audioViewModel = StateObject(wrappedValue: AudioMessageViewModel(url: url,
                                                                                   messageId: message.id))
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if isFromCurrentUser {
                    Spacer()
                }
                if !isDirect, !isFromCurrentUser {
                    VStack(spacing: 0) {
                        Spacer()
                        AsyncImage(
                            url: message.avatar,
                            placeholder: {
                                ZStack {
                                    Color(.lightBlue())
                                    Text(message.name.firstLetter.uppercased())
                                        .foreground(.white())
                                        .font(.medium(12))
                                }
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, -11)
                }
                BubbleView(direction: isFromCurrentUser ? .right : .left) {
                    VStack(alignment: .leading, spacing: 0) {
                        if message.isReply {
                            HStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 1)
                                    .frame(width: 2)
                                    .foreground(.blue(0.9))
                                    .padding(.top, 8)
                                    .padding(.leading, 16)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(message.name,
                                         [
                                            .font(.medium(13)),
                                            .paragraph(.init(lineHeightMultiple: 1.19, alignment: .left)),
                                            .color(.black())
                                        ]
                                    )
                                        .padding(.top, 8)
                                    Text(message.replyDescription,
                                         [
                                            .font(.regular(13)),
                                            .paragraph(.init(lineHeightMultiple: 1.2,
                                                             alignment: .left)),
                                            .color(.black())
                                        ]
                                    )
                                }
                                .frame(minWidth: 0, maxWidth: 70)
                                    .padding(.leading, 8)
                                    .padding(.trailing, 16)
                            }
                            .frame(height: 40)
                        }
                        HStack(spacing: 0) {
                            switch message.type {
                            case let .text(text):
                                textRow(message, text: text)
                            case let .location(location):
                                mapRow(location, date: message.shortDate)
                                    .sheet(isPresented: $showMap) {
                                        NavigationView {
                                            MapView(place: .init(
                                                name: "",
                                                latitude: location.lat,
                                                longitude: location.long
                                            ))
                                                .ignoresSafeArea()
                                                .navigationBarTitle(Text(R.string.localizable.chatGeoposition()))
                                                .navigationBarTitleDisplayMode(.inline)
                                        }
                                    }
                                    .onTapGesture {
                                        showMap.toggle()
                                    }
                            case let .image(url):
                                photoRow(message, url: url)
                                    .onTapGesture {
                                        onSelectPhoto?(url)
                                    }
                            case let .contact(name, phone, url):
                                contactRow(name: name, phone: phone, url: url)
                            case let .file(fileName, url):
                                fileRow(message, fileName: fileName, url: url)
                                    .sheet(isPresented: $showFile) {
                                        if let url = url {
                                            DocumentViewerView(url: url)
                                        }
                                    }
                                    .onTapGesture {
                                        showFile.toggle()
                                    }
                            case let .audio(_):
                                audioRow()
                            case .none:
                                EmptyView()
                            }
                        }
                    }
                    .background(.clear)
                }
                .padding(
                    .top,
                    calculateTopPadding(
                        isCurrentUser: isFromCurrentUser,
                        isPreviousFromCurrentUser: isPreviousFromCurrentUser
                    )
                )
                .padding(isFromCurrentUser ? .leading : .trailing, 8)

                if !isDirect, isFromCurrentUser {
                    VStack(spacing: 0) {
                        Spacer()

                        AsyncImage(
                            url: message.avatar,
                            placeholder: {
                                ZStack {
                                    Color(.lightBlue())
                                    Text(message.name.firstLetter.uppercased())
                                        .foreground(.white())
                                        .font(.medium(12))
                                }
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                    }
                    .padding(.trailing, 16)
                    .padding(.leading, -11)
                }

                if !isFromCurrentUser {
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showContactInfo, content: {
            ContactInfoView(data: chatContactInfo)
        })
        .onTapGesture {}
        .onAppear {
            if !isAnimating {
                isAnimating.toggle()
            }
        }
    }

    // MARK: - Private Methods

    private func textRow(_ message: RoomMessage, text: String) -> some View {
        HStack(spacing: 2) {
            Text(text)
                .lineLimit(nil)
                .font(.regular(15))
                .foreground(.black())
                .padding(.leading, !isFromCurrentUser ? 22 : 16)
                .padding([.top, .bottom], 12)

            VStack(alignment: .center) {
                Spacer()
                HStack(spacing: 8) {
                    Text(message.shortDate)
                        .frame(width: 40, height: 10)
                        .font(.light(12))
                        .foreground(.black(0.5))
                        .padding(.trailing, !isFromCurrentUser ? 16 : 0)

                    if isFromCurrentUser {
                        Image(R.image.chat.readCheck.name)
                            .resizable()
                            .frame(width: 13.5, height: 10, alignment: .center)
                            .padding(.trailing, 16)
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }

    private func mapRow(_ location: Location, date: String) -> some View {
        ZStack {
            MapSnapshotView(latitude: location.lat, longitude: location.long)
            checkReadView(date)
        }
        .frame(width: 247, height: 142)
    }

    private func photoRow(_ message: RoomMessage, url: URL?) -> some View {
        ZStack {
            AsyncImage(
                url: url,
                placeholder: { ShimmerView().frame(width: 202, height: 245) },
                result: { Image(uiImage: $0).resizable() }
            )
                .scaledToFill()
                .frame(width: 202, height: 245)

            checkReadView(message.shortDate)
                .padding(.leading, isFromCurrentUser ? 0 : 130)
        }
        .frame(width: 202, height: 245)
    }

    private func fileRow(_ message: RoomMessage, fileName: String, url: URL?) -> some View {
        ZStack {
            HStack(spacing: 0) {
                if let url = url {
                    PDFKitView(url: url)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .padding(.leading, 8)
                } else {
                    ShimmerView()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .padding(.leading, 8)
                }

                VStack(spacing: 4) {
                    Spacer()
                    Text(fileName, [
                        .color(.black()),
                        .font(.medium(15)),
                        .paragraph(.init(lineHeightMultiple: 1.26, alignment: .left))
                    ]).frame(height: 23)
                    Spacer()
                }.padding(.leading, 11)

                Spacer()
            }

            checkReadView(message.shortDate)
                .padding(.leading, isFromCurrentUser ? 0 : 130)
        }
        .frame(width: 247, height: 96)
    }

    private func audioRow() -> some View {
        return ZStack {
            HStack(alignment: .center, spacing: 12) {
                Button(action: audioViewModel.play) {
                    ZStack {
                        Circle()
                            .frame(width: 48,
                                   height: 48)
                        !audioViewModel.isPlaying ? R.image.chat.audio.audioPlay.image : R.image.chat.audio.audioStop.image
                    }
                }
                .padding(.vertical, 8)
                .padding(.leading, message.isCurrentUser ? 8 : 16)
                VStack(alignment: .leading, spacing: 10) {
                    SliderAudioView(value: Binding(get: { audioViewModel.time }, set: { newValue in
                        audioViewModel.time = newValue
                        audioViewModel.audioPlayer?.currentTime = Double(audioViewModel.time) * (audioViewModel.audioPlayer?.duration ?? 0)
                        audioViewModel.audioPlayer?.play()
                    }), activateShowCard: $activateShowCard)
                    .frame(width: 177, height: 1)
                    Text(message.audioDuration)
                        .font(.regular(12))
                        .foreground(.darkGray())
                }
                .padding(.top, 20)
                .padding(.trailing, 7)
            }
            checkTextReadView(message.shortDate)
                .padding(.leading, isFromCurrentUser ? 0 : 185)
        }
        .onReceive(audioViewModel.timer) { _ in
            audioViewModel.onTimerChange()
        }
        .onChange(of: audioViewModel.playingAudioId, perform: { value in
            playingAudioId = value
        })
        .onAppear {
            self.audioViewModel.setupAudioNew { url in
                do {
                    guard let unwrappedUrl = url else { return }
                    audioViewModel.audioPlayer = try AVAudioPlayer(contentsOf: unwrappedUrl)
                    audioViewModel.audioPlayer?.numberOfLoops = .zero
                } catch {
                    debugPrint("Error URL")
                    return
                }
            }
        }
        .onChange(of: playingAudioId, perform: { _ in
            if message.id != playingAudioId {
                audioViewModel.stop()
            }
        })
        .frame(width: 252, height: 64)
    }

    private func contactRow(name: String, phone: String?, url: URL?) -> some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    AsyncImage(
                        url: url,
                        placeholder: { ShimmerView().frame(width: 40, height: 40) },
                        result: { Image(uiImage: $0).resizable() }
                    )
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .cornerRadius(20)

                    VStack(alignment: .leading, spacing: 0) {
                        Text(name)
                            .font(.semibold(15))
                            .foreground(.black())
                        Spacer()
                        Text(phone ?? "-")
                            .font(.regular(13))
                            .foreground(.darkGray())
                    }
                    Spacer()
                }
                .frame(height: 40)

                Button(action: {
                    chatContactInfo = ChatContactInfo(name: name,
                                                      phone: phone,
                                                      url: url)
                    showContactInfo = true
                }, label: {
                    Text("Просмотр контакта")
                        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44, alignment: .center)
                        .font(.bold(15))
                        .foreground(.blue())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.blue()), lineWidth: 1)
                        )
                })
                    .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44, alignment: .center)
                    .padding(.top, 12)

                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            checkTextReadView(message.shortDate)
        }
        .frame(width: 244, height: 138)
    }

    private func reactions(_ items: [Reaction]) -> some View {
        ZStack {
            VStack {
                Spacer()
                HStack(spacing: 4) {
                    if isFromCurrentUser {
                        Spacer()
                    }
                    ForEach(items) { reaction in
                        ReactionGroupView(
                            text: reaction.emoji,
                            count: 1,
                            backgroundColor: Color(.white())
                        ).onTapGesture {
                            onReaction?(reaction.id)
                        }
                    }

                    if !isFromCurrentUser {
                        Spacer()
                    }
                }
                .frame(height: 24)
                .padding(isFromCurrentUser ? .trailing : .leading, 32)
            }
        }
    }

    private func checkTextReadView(_ time: String) -> some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    if isFromCurrentUser {
                        Spacer()
                    }
                    HStack(spacing: 6) {
                        Text(time)
                            .frame(width: 40, height: 10)
                            .font(.light(12))
                            .foreground(.black(0.5))
                            .padding(.trailing, !isFromCurrentUser ? 16 : 0)
                            .padding(.leading, isFromCurrentUser ? 0 : 16)

                        if isFromCurrentUser {
                            Image(R.image.chat.readCheck.name)
                                .resizable()
                                .frame(width: 13.5, height: 10, alignment: .center)
                                .padding(.trailing, 16)
                        }
                    }
                    if !isFromCurrentUser {
                        Spacer()
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }

    private func checkReadView(_ time: String) -> some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    if isFromCurrentUser {
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 4) {
                        Text(time)
                            .font(.light(12))
                            .foreground(.white())

                        Image(R.image.chat.readCheckWhite.name)
                    }
                    .frame(width: 56, height: 16)
                    .background(.black(0.4))
                    .cornerRadius(8)

                    if !isFromCurrentUser {
                        Spacer()
                    }
                }
                .padding(.bottom, 8)
                .padding(isFromCurrentUser ? .trailing : .leading, 10)
            }
        }
    }

    private func calculateTopPadding(isCurrentUser: Bool, isPreviousFromCurrentUser: Bool) -> CGFloat {
        if isCurrentUser {
            return isPreviousFromCurrentUser ? 8 : 8
        } else {
            return isPreviousFromCurrentUser ? 8 : 8
        }
    }
}
