import SwiftUI

// MARK: - ChatHistoryRow

struct ChatHistoryRow: View {

    // MARK: - Internal Properties

    let room: AuraRoom

    // MARK: - Private Properties

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                AsyncImage(url: room.roomAvatar) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        ZStack {
                            Color(.lightBlue())
                            Text(room.summary.displayname?.firstLetter.uppercased() ?? "?")
                                .foreground(.white())
                                .font(.medium(26))
                        }
                    }
                }
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(30)

                if room.isDirect {
                    ZStack {
                        Circle().fill(.white).frame(width: 16, height: 16)
                        Circle().fill(Color(room.isOnline ? .green() : .gray())).frame(width: 12, height: 12)
                    }.padding([.leading, .top], 48)
                }
            }
            .frame(width: 60, height: 60)

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text(room.summary.displayname?.firstUppercased ?? "",
                        [
                            .font(.semibold(15)),
                            .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                            .color(.black())
                        ]
                    )
                    Spacer()
                    Text(
                        Calendar.current.isDateInYesterday(room.summary.lastMessageDate)
                        || room.summary.lastMessageDate.is24HoursHavePassed
                        ? room.summary.lastMessageDate.dayAndMonthAndYear
                        : room.summary.lastMessageDate.hoursAndMinutes,
                        [
                            .font(.regular(13)),
                            .color(.black222222(0.6))
                        ]
                    )
                }
                .padding(.top, 9)

                HStack(spacing: 12) {
                    Text(
                        room.lastMessage,
                        [
                            .font(.regular(15)),
                            .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                            .color(.black(0.6))
                        ]
                    )
                        .lineLimit(2)

                    Spacer()

                    if room.summary.localUnreadEventCount > 0 {
                        HStack(alignment: .center) {
                            Text(room.summary.localUnreadEventCount.description)
                                .font(.regular(13))
                                .foreground(.white())
                                .padding([.leading, .trailing], 7)
                                .padding([.top, .bottom], 2)
                        }
                        .frame(height: 20, alignment: .center)
                        .background(.red())
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 2)
                Spacer()
                Rectangle().fill(Color(.grayE6EAED())).frame(height: 1)
            }
        }
        .frame(height: 80)
        .padding([.leading, .trailing], 16)
    }
}