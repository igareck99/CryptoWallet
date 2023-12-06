import SwiftUI

protocol SelectTokenViewFactoryProtocol {
    static func makeItems(
        addresses: [WalletInfo],
        delegate: SelectTokenViewModelDelegate
    ) -> [any ViewGeneratable]

    static func makeItem(
        address: WalletInfo,
        delegate: SelectTokenViewModelDelegate
    ) -> any ViewGeneratable
}

enum SelectTokenViewFactory {}

// MARK: - SelectTokenViewFactoryProtocol

extension SelectTokenViewFactory: SelectTokenViewFactoryProtocol {
    static func makeItems(
        addresses: [WalletInfo],
        delegate: SelectTokenViewModelDelegate
    ) -> [any ViewGeneratable] {
        addresses.map {
            makeItem(
                address: $0,
                delegate: delegate
            )
        }
    }
    
    static func makeItem(
        address: WalletInfo,
        delegate: SelectTokenViewModelDelegate
    ) -> any ViewGeneratable {
        TokenViewModel(
            address: address.address,
            coinAmount: address.coinAmount,
            currency: address.result.currency
        ) {
            delegate.address = address
            delegate.showSelectToken = false
        }
    }
}
