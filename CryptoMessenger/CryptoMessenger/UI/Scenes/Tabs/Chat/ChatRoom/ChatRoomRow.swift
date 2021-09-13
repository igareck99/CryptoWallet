import SwiftUI

// MARK: - ChatRoomRow

struct ChatRoomRow: View {

    // MARK: - Private Properties

    private let message: RoomMessage
    private let isPreviousFromCurrentUser: Bool
    private var onReaction: StringBlock?
    @State private var showMap = false

    // MARK: - Lifecycle

    init(message: RoomMessage, isPreviousFromCurrentUser: Bool, onReaction: StringBlock?) {
        self.message = message
        self.isPreviousFromCurrentUser = isPreviousFromCurrentUser
        self.onReaction = onReaction
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            HStack {
                if message.isCurrentUser {
                    Spacer()
                }

                BubbleView(direction: message.isCurrentUser ? .right : .left) {
                    HStack {
                        switch message.type {
                        case let .text(text):
                            textRow(text)
                                .padding([.top, .bottom], 12)
                                .padding(.leading, message.isCurrentUser ? 22 : 16)
                                .padding(.trailing, message.isCurrentUser ? 16 : 22)
                        case let .location(location):
                            mapRow(location)
                                .sheet(isPresented: $showMap) {
                                    NavigationView {
                                        MapView(place:
                                                    .init(
                                                        name: "",
                                                        latitude: location.lat,
                                                        longitude: location.long
                                                    )
                                        )
                                        .ignoresSafeArea()
                                        .navigationBarTitle(Text("Геопозиция"))
                                        .navigationBarTitleDisplayMode(.inline)
                                    }
                                }
                                .onTapGesture {
                                    showMap.toggle()
                                }
                        case let .image(image):
                            photoRow(image)
                        }
                    }
                    .background(.clear)
                }
                .padding(
                    .top,
                    calculateTopPadding(
                        isCurrentUser: message.isCurrentUser,
                        isPreviousFromCurrentUser: isPreviousFromCurrentUser
                    )
                )
                .padding(message.isCurrentUser ? .leading : .trailing, 8)

                if !message.isCurrentUser {
                    Spacer()
                }
            }

            if !message.reactions.isEmpty {
                reactions()
                    .padding(.bottom, -16)
            }
        }
        .id(message.id)
        .onTapGesture {

        }
//        .simultaneousGesture(
//            LongPressGesture(minimumDuration: 0.4)
//                .onEnded { _ in
//                    vibrate()
////                    messageId = message.id
////                    cardPosition = .middle
//                }
//        )
    }

    // MARK: - Private Methods

    private func textRow(_ text: String) -> some View {
        HStack {
            Text(text)
                .lineLimit(nil)
                .font(.regular(15))
                .foreground(.black())

            VStack {
                Spacer()

                Text(message.date)
                    .frame(height: 10)
                    .font(.light(12))
                    .foreground(.black(0.5))
                    .padding(.bottom, -3)
            }

            if message.isCurrentUser {
                VStack {
                    Spacer()

                    Image(R.image.chat.readCheck.name)
                        .resizable()
                        .frame(width: 13.5, height: 10, alignment: .center)
                        .padding(.bottom, -3)
                }
            }
        }
    }

    private func mapRow(_ location: Location) -> some View {
        ZStack {
            MapView(place: .init(name: "", latitude: location.lat, longitude: location.long), true)

            checkReadView()
        }
        .frame(width: 247, height: 142)
    }

    private func photoRow(_ uiImage: UIImage) -> some View {
        ZStack {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 202, height: 245, alignment: .center)

            checkReadView()
        }
        .frame(width: 202, height: 245)
    }

    private func reactions() -> some View {
        ZStack {
            VStack {
                Spacer()

                HStack(spacing: 4) {
                    if message.isCurrentUser {
                        Spacer()
                    }

                    ForEach(message.reactions) { reaction in
                        ReactionGroupView(
                            text: reaction.emoji,
                            count: 1,
                            backgroundColor: Color(.white())
                        ).onTapGesture {
                            onReaction?(reaction.id)
                        }
                    }

                    if !message.isCurrentUser {
                        Spacer()
                    }
                }
                .frame(height: 24)
                .padding(message.isCurrentUser ? .trailing : .leading, 32)
            }
        }
    }

    private func checkReadView() -> some View {
        ZStack {
            VStack {
                Spacer()

                HStack {
                    if message.isCurrentUser {
                        Spacer()
                    }

                    HStack(alignment: .center, spacing: 4) {
                        Text("14:47")
                            .font(.light(12))
                            .foreground(.white())

                        Image(R.image.chat.readCheckWhite.name)
                    }
                    .frame(width: 56, height: 16)
                    .background(.black(0.4))
                    .cornerRadius(8)

                    if !message.isCurrentUser {
                        Spacer()
                    }
                }
                .padding(.bottom, 8)
                .padding(message.isCurrentUser ? .trailing : .leading, 10)
            }
        }
    }

    private func calculateTopPadding(isCurrentUser: Bool, isPreviousFromCurrentUser: Bool) -> CGFloat {
        if isCurrentUser {
            return isPreviousFromCurrentUser ? 12 : 28
        } else {
            return isPreviousFromCurrentUser ? 28 : 12
        }
    }
}
