import SwiftUI

struct ReactionsGridModel: Identifiable, ViewGeneratable {
    let id = UUID()
    let reactionItems: [ReactionTextsItem]
    let reactionsHeight: CGFloat

    init(
        reactionItems: [ReactionTextsItem],
        reactionsHeight: CGFloat = .zero
    ) {
        self.reactionItems = reactionItems
        self.reactionsHeight = reactionsHeight
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ReactionsGrid(
            totalHeight: Binding(get: {
                reactionsHeight
            }, set: { value in
                debugPrint("\(value)")
            }),
            viewModel: ReactionsGroupViewModel(items: reactionItems)
        ).anyView()
    }
}
