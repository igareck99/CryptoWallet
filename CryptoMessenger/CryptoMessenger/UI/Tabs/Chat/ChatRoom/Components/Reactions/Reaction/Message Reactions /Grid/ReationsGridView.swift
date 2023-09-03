import SwiftUI

// MARK: - ReationsGridView

struct ReationsGridView: View {

    // MARK: - Internal Properties

    let data: ReactionsNewViewModel
    @State private var showAll = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                ForEach(data.firstRow, id: \.id) { value in
                    value.view()
                }
            }
            HStack(spacing: 4) {
                ForEach(getView(), id: \.id) { value in
                    value.view()
                }
            }
        }
    }

    // MARK: - Private Methods

    private func getView() -> [any ViewGeneratable] {
        if data.views.count - data.firstRow.count > 0 && !showAll {
            let emojiString = "+" + (data.views.count - data.firstRow.count).value
            let object = ReactionNewEvent(eventId: "",
                                          sender: "",
                                          timestamp: Date(),
                                          emoji: "",
                                          color: data.backgroundColor,
                                          emojiString: emojiString,
                                          textColor: .brilliantAzure,
            let object = ReactionNewEvent(eventId: "",
                                          sender: "",
                                          timestamp: Date(),
                                          emoji: "+",
                                          color: data.backgroundColor,
                                          textColor: .white,
                                          emojiCount: data.views.count - 4,
                                          type: .add) { _ in
                showAll = true
            }
            return [object]
        } else {
            return data.secondRow
        }
    }
}
