import Foundation

// MARK: - AnswerItem

struct AnswerItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var title: String
    var details: [AnswerDetailItem]
    var tapped = false

}

// MARK: - AnswerItem

struct AnswerDetailItem: Identifiable, Hashable {

    // MARK: - Internal Properties

    let id = UUID()
    var text: String
}
