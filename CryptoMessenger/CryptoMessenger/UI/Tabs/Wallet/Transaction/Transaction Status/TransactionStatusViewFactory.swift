import Foundation

protocol TransactionStatusViewFactoryProtocol {
    static func makeItems(model: TransactionStatus) -> [any ViewGeneratable]
}

enum TransactionStatusViewFactory {}

// MARK: - TransactionStatusViewFactoryProtocol

extension TransactionStatusViewFactory: TransactionStatusViewFactoryProtocol {
    static func makeItems(model: TransactionStatus) -> [any ViewGeneratable] {
        [ SheetDragItem() ] + model.keysAndValues.map {
            makeItem(leadingText: $0.leftText, trailingText: $0.rightText)
        }
    }

    static func makeItem(
        leadingText: String,
        trailingText: String
    ) -> any ViewGeneratable {
        TransactionStatusItem(
            leadingText: leadingText,
            trailingText: trailingText
        )
    }
}

extension TransactionStatusViewFactory {
    static func mockItems() -> [any ViewGeneratable] {
        [
            SheetDragItem(),
            TransactionStatusItem(
                leadingText: "Отправитель",
                trailingText: "0x829bd824b016326a401d083b33d092293333a830"
            ),
            TransactionStatusItem(
                leadingText: "Получатель",
                trailingText: "0x829bd824b016326a401d083b33d092293333a830"
            ),
            TransactionStatusItem(
                leadingText: "Блок",
                trailingText: "829824016326"
            ),
            TransactionStatusItem(
                leadingText: "Хэш",
                trailingText: "0x7bd02d46b153704780d4d4e6e04e93f511a29616f394e9d9f9f6bec265f5d9d2"
            ),
            TransactionStatusItem(
                leadingText: "Дата",
                trailingText: "26 июля 2022"
            ),
            TransactionStatusItem(
                leadingText: "Сумма",
                trailingText: "0.0000074"
            ),
            TransactionStatusItem(
                leadingText: "Статус",
                trailingText: "Успешно подтверждена" // Ожидает подтверждения
            ),
        ]
    }
}
