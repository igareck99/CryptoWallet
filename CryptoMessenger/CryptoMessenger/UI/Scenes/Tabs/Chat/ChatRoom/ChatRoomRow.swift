import MatrixSDK
import SwiftUI

// MARK: - ChatRoomRow

struct ChatRoomRow: View {

    // MARK: - Private Properties

    private let message: RoomMessage
    private let isFromCurrentUser: Bool
    private let isPreviousFromCurrentUser: Bool
    private var onReaction: StringBlock?
    @State private var showMap = false
    @State private var isAnimating = false

    // MARK: - Lifecycle

    init(message: RoomMessage, isPreviousFromCurrentUser: Bool, onReaction: StringBlock?) {
        self.message = message
        self.isFromCurrentUser = message.isCurrentUser
        self.isPreviousFromCurrentUser = isPreviousFromCurrentUser
        self.onReaction = onReaction
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if isFromCurrentUser {
                    Spacer()
                }

                BubbleView(direction: isFromCurrentUser ? .right : .left) {
                    HStack(spacing: 0) {
                        switch message.type {
                        case let .text(text):
                            textRow(message, text: text)
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
                        case .contact:
                            contactRow()
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

                if !isFromCurrentUser {
                    Spacer()
                }
            }

//            if !message.reactions.isEmpty {
//                reactions()
//                    .padding(.bottom, -18)
//                    .opacity(isAnimating ? 1 : 0)
//                    .animation(.easeInOut)
//            }
        }
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
                        Text(message.date)
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

    private func mapRow(_ location: Location) -> some View {
        ZStack {
            MapSnapshotView(latitude: location.lat, longitude: location.long)

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

    private func contactRow() -> some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    R.image.chat.mockAvatar2.image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40, alignment: .center)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Виолетта Силенина")
                            .font(.semibold(15))
                            .foreground(.black())

                        Spacer()

                        Text("+7(925)813-31-62")
                            .font(.regular(13))
                            .foreground(.darkGray())
                    }
                }
                .frame(height: 40)

                Button(action: {

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
                .padding(.trailing, 8)
                .padding(.leading, 24)

                Spacer()
            }
            .padding([.top, .trailing], 8)
            .padding(.leading, -16)

            checkTextReadView()
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

    private func checkTextReadView() -> some View {
        ZStack {
            VStack {
                Spacer()

                HStack {
                    if isFromCurrentUser {
                        Spacer()
                    }

                    HStack(spacing: 6) {
                        Text(Date().hoursAndMinutes)
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

                    if !isFromCurrentUser {
                        Spacer()
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }

    private func checkReadView() -> some View {
        ZStack {
            VStack {
                Spacer()

                HStack {
                    if isFromCurrentUser {
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
