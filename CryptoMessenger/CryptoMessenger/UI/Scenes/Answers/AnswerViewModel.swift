import SwiftUI

// MARK: - AnswersViewModel

final class AnswersViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: AnswersSceneDelegate?

    @Published var listData = [AnswerItem(title: "Загрузка и установка AURA",
                                          details: []),
                               AnswerItem(title: "Подтверждение",
                                          details: []),
                               AnswerItem(title: "Статус и заметки",
                                          details: [AnswerDetailItem(text: "Как поделиться Aura аккаунтом в других приложениях"),
                                                    AnswerDetailItem(text: "О конфиденциальности статусов"),
                                                    AnswerDetailItem(text: "Как пользоваться функцией “Заметкой”")]),
                               AnswerItem(title: R.string.localizable.additionalMenuChats(),
                                          details: []),
                               AnswerItem(title: "Контакты",
                                          details: []),
                               AnswerItem(title: "Аудио и видеозвонки",
                                          details: [])
    ]
}
