import SwiftUI

struct CallItem: Identifiable, ViewGeneratable {
    let id = UUID()
    let phoneImageName: String
    let subtitle: String
    let type: CallItemType
    let onTap: () -> Void

    init(
        phoneImageName: String = "phone.circle.fill",
        subtitle: String,
        type: CallItemType,
        onTap: @escaping () -> Void
    ) {
        self.phoneImageName = phoneImageName
        self.subtitle = subtitle
        self.type = type
        self.onTap = onTap
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        CallItemView(model: self).anyView()
    }
}

struct CallItemType {
    let title: String
    let imageName: String
    let imageColor: Color

    static let incomeAnswered = CallItemType(
        title: "Входящий звонок",
        imageName: "arrow.down.left",
        imageColor: .dodgerBlue
    )

    static let incomeUnanswered = CallItemType(
        title: "Входящий звонок",
        imageName: "arrow.down.left",
        imageColor: .spanishCrimson
    )

    static let outcomeAnswered = CallItemType(
        title: "Исходящий звонок",
        imageName: "arrow.up.right",
        imageColor: .dodgerBlue
    )

    static let outcomeUnanswered = CallItemType(
        title: "Исходящий звонок",
        imageName: "arrow.up.right",
        imageColor: .spanishCrimson
    )
}
