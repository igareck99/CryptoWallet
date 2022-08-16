import SwiftUI

struct ReactionsView: View {

	private let items: [Reaction]
	private let isFromCurrentUser: Bool
	private let onReactionHandler: StringBlock?

	init(
		items: [Reaction],
		isFromCurrentUser: Bool,
		onReactionHandler: StringBlock?
	) {
		self.items = items
		self.isFromCurrentUser = isFromCurrentUser
		self.onReactionHandler = onReactionHandler
	}

    var body: some View {
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
							onReactionHandler?(reaction.id)
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
}
