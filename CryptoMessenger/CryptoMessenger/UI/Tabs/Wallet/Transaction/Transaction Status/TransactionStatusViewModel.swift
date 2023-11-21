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

    init(
        factory: TransactionStatusViewFactoryProtocol.Type = TransactionStatusViewFactory.self
    ) {
        self.factory = factory
    }

    func makeItems() {
        let items = factory.makeItems()
        let itemsHeight: CGFloat = items.reduce(into: .zero) { $0 += $1.getItemHeight() }
        height = itemsHeight + 82
        displayItems = factory.makeItems()
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
