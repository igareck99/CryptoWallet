import SwiftUI

struct TransactionStatusItem: ViewGeneratable {
    let id = UUID()
    let leadingText: String
    let trailingText: String
    let leadingTextColor: Color
    let trailingTextColor: Color

    init(
        leadingText: String,
        trailingText: String,
        leadingTextColor: Color = .chineseBlack,
        trailingTextColor: Color = .romanSilver // greenCrayola royalOrange
    ) {
        self.leadingText = leadingText
        self.trailingText = trailingText
        self.leadingTextColor = leadingTextColor
        self.trailingTextColor = trailingTextColor
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        TransactionStatusItemView(
            model: self
        ).anyView()
    }

    func getItemHeight() -> CGFloat {
        54
    }
}
