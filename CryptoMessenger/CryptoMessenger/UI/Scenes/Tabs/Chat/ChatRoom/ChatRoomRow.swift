import SwiftUI

struct ChatRoomRow: View {

    private let message: RoomMessage
    private let isCurrentUser: Bool?

    @State private var showMap = false

    init(message: RoomMessage, isCurrentUser: Bool?) {
        self.message = message
        self.isCurrentUser = isCurrentUser
    }

    var body: some View {
            HStack {
                if message.isCurrentUser {
                    Spacer()
                }

                ChatBubble(direction: message.isCurrentUser ? .right : .left) {
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
                        default:
                            EmptyView()
                        }
                    }
                    .modifier(BubbleModifier(isCurrentUser: message.isCurrentUser))
                }
                .padding(
                    .top,
                    message.isCurrentUser == isCurrentUser ? 12 : 28
                )
                .padding(message.isCurrentUser ? .leading : .trailing, 8)

                if !message.isCurrentUser {
                    Spacer()
                }
            }
            .id(message.id)
    }

    private func textRow(_ text: String) -> some View {
        HStack {
            Text(text)
                .lineLimit(nil)

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
            MapView(place: .init(name: "", latitude: location.lat, longitude: location.long))
                .border(Color(.custom(#colorLiteral(red: 0.7921568627, green: 0.8117647059, blue: 0.8235294118, alpha: 1))), width: 1)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)

            ZStack {
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        HStack(alignment: .center, spacing: 4) {
                            Text("14:47")
                                .font(.light(12))
                                .foreground(.white())

                            Image(R.image.chat.readCheckWhite.name)
                        }
                        .frame(width: 56, height: 16)
                        .background(.black(0.4))
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 8)
                    .padding(.trailing, 8)
                }
            }
        }
        .frame(width: 247, height: 142)
    }
}
