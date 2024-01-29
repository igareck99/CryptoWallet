import SwiftUI

struct CallItem: Identifiable, ViewGeneratable {
    let id = UUID()
    let phoneImageName: String
    let subtitle: String
    let type: CallItemType
    let onTap: () -> Void

    init(
        phoneImageName: String = CallItemSources.phoneImage,
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
    let image: Image

    static let sources: CallItemSourcesable.Type = CallItemSources.self

    static let incomeAnswered = CallItemType(
        title: sources.incomingCall,
        image: sources.incomingCallImage
    )

    static let incomeUnanswered = CallItemType(
        title: sources.incomingCall,
        image: sources.incomingCallUnanwseredImage
    )

    static let outcomeAnswered = CallItemType(
        title: sources.outcomingCall,
        image: sources.outcomingCallImage
    )

    static let outcomeUnanswered = CallItemType(
        title: sources.outcomingCall,
        image: sources.outcomingCallUnanwseredImage
    )
}
