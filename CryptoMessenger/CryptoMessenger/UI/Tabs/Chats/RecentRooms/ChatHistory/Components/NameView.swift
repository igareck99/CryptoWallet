import SwiftUI

// MARK: - NameViewModel

struct NameViewModel: Identifiable, ViewGeneratable {

    var id = UUID()
    let lastMessageTime: Date
    let roomName: String
    let unreadEventsCountView: Int
    let isPinned: Bool

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
        VStack(alignment: .trailing, spacing: nil) {
            dateView()
            unreadEventsCountView()
        }
    }

    private func dateView() -> some View {
        Text(
            Calendar.current.isDateInYesterday(data.lastMessageTime)
            || data.lastMessageTime.is24HoursHavePassed
            ? data.lastMessageTime.dayAndMonthAndYear
            : data.lastMessageTime.hoursAndMinutes
        )
        .font(.subheadline2Regular14)
        .foreground(Color.romanSilver07)
    }
    
    @ViewBuilder
    private func unreadEventsCountView() -> some View {
        // TODO: - Спросить как будут выглядеть одновременно
        if data.unreadEventsCountView > 0 {
            ZStack(alignment: .center) {
                Circle()
                    .frame(height: 20, alignment: .center)
                    .foregroundColor(Color.spanishCrimson)
                    .cornerRadius(10)
                Text(data.unreadEventsCountView.description)
                    .font(.subheadline2Regular14)
                    .foreground(.white)
            }
        } else {
            if data.isPinned {
                R.image.chat.pin.image
                    .padding(.top, 14)
            }

        }
    }
}
