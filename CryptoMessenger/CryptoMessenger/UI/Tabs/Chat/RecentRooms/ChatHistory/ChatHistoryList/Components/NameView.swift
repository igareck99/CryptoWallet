import SwiftUI

// MARK: - NameViewModel

struct NameViewModel: Identifiable, ViewGeneratable {
    
    var id = UUID()
    let lastMessageTime: Date
    let roomName: String
    
    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        NameView(data: self).anyView()
    }
}

// MARK: - NameView

struct NameView: View {
    
    let data: NameViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            displayNameView()
            Spacer()
            dateView()
                .padding(.trailing, 16)
        }
    }

    private func dateView() -> some View {
        Text(
            Calendar.current.isDateInYesterday(data.lastMessageTime)
            || data.lastMessageTime.is24HoursHavePassed
            ? data.lastMessageTime.dayAndMonthAndYear
            : data.lastMessageTime.hoursAndMinutes,
            [
                .font(.regular(14)),
                .color(Color(.custom(.init( 133, 135, 141))))
            ]
        )
    }
    
    private func displayNameView() -> some View {
        AnyView(
            Text(
                data.roomName.firstUppercased,
                [
                    .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left))
                ]
            ).font(.system(size: 16, weight: .medium))
                .foregroundColor(.chineseBlack)
        )
    }
}
