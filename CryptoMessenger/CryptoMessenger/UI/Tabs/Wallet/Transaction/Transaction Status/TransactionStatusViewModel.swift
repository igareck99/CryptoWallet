import SwiftUI

protocol TransactionStatusViewModelProtocol: ObservableObject {
    var displayItems: [any ViewGeneratable] { get }
    var height: CGFloat { get }

    func didTapOpenWalletButton()
    func onAppear()
}

final class TransactionStatusViewModel: ObservableObject {
    @Published var displayItems = [any ViewGeneratable]()
    @Published var height: CGFloat = 514
    private let factory: TransactionStatusViewFactoryProtocol.Type
    private let model: TransactionStatus

    init(
        model: TransactionStatus,
        factory: TransactionStatusViewFactoryProtocol.Type = TransactionStatusViewFactory.self
    ) {
        self.model = model
        self.factory = factory
    }

    func makeItems() {
        let items = factory.makeItems(model: model)
        let itemsHeight: CGFloat = items.reduce(into: .zero) { $0 += $1.getItemHeight() }
        height = itemsHeight + 90
        displayItems = items
    }
}

// MARK: - TransactionStatusViewProtocol

extension TransactionStatusViewModel: TransactionStatusViewModelProtocol {
    func onAppear() {
        makeItems()
    }

    func didTapOpenWalletButton() {
        debugPrint("didTapOpenWalletButton")
    }
}
