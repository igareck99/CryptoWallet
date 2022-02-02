import SwiftUI

// MARK: - AnswersViewModel

final class AnswersViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: AnswersSceneDelegate?

    @Published var listData = [AnswerItem(title: R.string.localizable.answersLoad(),
                                          details: []),
                               AnswerItem(title: R.string.localizable.answersConfirmation(),
                                          details: []),
                               AnswerItem(title: R.string.localizable.answersNotes(),
                                          details: [AnswerDetailItem(text: R.string.localizable.answersNotesShare()),
                                                    AnswerDetailItem(text: R.string.localizable.answersNotesPrivacy()),
                                                    AnswerDetailItem(text: R.string.localizable.answersNotesHowUse())]),
                               AnswerItem(title: R.string.localizable.additionalMenuChats(),
                                          details: []),
                               AnswerItem(title: R.string.localizable.answersContacts(),
                                          details: []),
                               AnswerItem(title: R.string.localizable.answersAudioVideo(),
                                          details: []),
                               AnswerItem(title: R.string.localizable.answersLoad(),
                                          details: [])
    ]
}
