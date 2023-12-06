import SwiftUI

protocol SelectTokenViewModelProtocol: ObservableObject {
    var displayItems: [any ViewGeneratable] { get }
    var showSelectToken: Bool { get set }
    var address: WalletInfo { get set }
    var addresses: [WalletInfo] { get }
    var height: CGFloat { get set }
    var resources: SelectTokenResourcable.Type { get }
}

protocol SelectTokenViewModelDelegate: AnyObject {
    var showSelectToken: Bool { get set }
    var address: WalletInfo { get set }
}

final class SelectTokenViewModel: SelectTokenViewModelProtocol, SelectTokenViewModelDelegate {

    @Published var displayItems = [any ViewGeneratable]()
    @Published var height: CGFloat
    @Binding var showSelectToken: Bool
    @Binding var address: WalletInfo
    let addresses: [WalletInfo]
    let resources: SelectTokenResourcable.Type
    private let factory: SelectTokenViewFactoryProtocol.Type

    init(
        addresses: [WalletInfo],
        showSelectToken: Binding<Bool>,
        address: Binding<WalletInfo>,
        resources: SelectTokenResourcable.Type = SelectTokenResources.self,
        factory: SelectTokenViewFactoryProtocol.Type = SelectTokenViewFactory.self
    ) {
        self.addresses = addresses
        self._showSelectToken = showSelectToken
        self._address = address
        self.factory = factory
        self.resources = resources
        self.height = CGFloat(addresses.count * 64 + 50)
        makeItems()
    }

    private func makeItems() {
        displayItems = factory.makeItems(
            addresses: addresses,
            delegate: self
        )
    }
}
