import SwiftUI

struct ChatRoomRow: View {

    private let message: RoomMessage
    private let isCurrentUser: Bool?

    init(message: RoomMessage, isCurrentUser: Bool?) {
        self.message = message
        self.isCurrentUser = isCurrentUser
    }
    
    var body: some View {
        switch message.type {
        case let .text(text):
            HStack {
                if message.isCurrentUser {
                    Spacer()
                }

                ChatBubble(direction: message.isCurrentUser ? .right : .left) {
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
        default:
            EmptyView()
        }
    }
}
