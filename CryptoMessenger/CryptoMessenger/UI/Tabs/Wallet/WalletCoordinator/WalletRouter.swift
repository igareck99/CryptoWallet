import SwiftUI

protocol WalletRouterable {

    func transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    )
    func importKey(coordinator: WalletCoordinatable)
    func popToRoot()

    func routePath() -> Binding<NavigationPath>
    func presentedItem() -> Binding<WalletSheetLink?>
}

struct WalletRouter<Content: View, State: WalletRouterStatable>: View {

    @ObservedObject var state: State

    var content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(item: $state.presentedItem, content: sheetContent)
                .navigationDestination(
                    for: WalletContentLink.self,
                    destination: linkDestination
                )
        }
    }

    @ViewBuilder
    private func linkDestination(link: WalletContentLink) -> some View {
        switch link {
        case let .transaction(filterIndex, tokenIndex, address, coordinator):
            TransactionConfigurator.build(
                selectorFilterIndex: filterIndex,
                selectorTokenIndex: tokenIndex,
                address: address,
                coordinator: coordinator
            )
        case let .importKey(coordinator):
            ImportKeyConfigurator.build(coordinator: coordinator)
        case let .transfer(wallet, coordinator):
            TransferConfigurator.build(wallet: wallet, coordinator: coordinator)
        case let .chooseReceiver(address, coordinator):
            ChooseReceiverConfigurator.build(receiverData: address, coordinator: coordinator)
        case let .facilityApprove(transaction, coordinator):
            FacilityApproveConfigurator.build(
                transaction: transaction,
                coordinator: coordinator
            )
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func sheetContent(item: WalletSheetLink) -> some View {
        switch item {
        case let .transactionResult(model):
            TransactionResultAssembly.build(model: model)
        default:
            EmptyView()
        }
    }
}

// MARK: - WalletRouterable

extension WalletRouter: WalletRouterable {

    func routePath() -> Binding<NavigationPath> {
        $state.path
    }

    func presentedItem() -> Binding<WalletSheetLink?> {
        $state.presentedItem
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }

    func transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    ) {
        state.path.append(
            WalletContentLink.transaction(
                filterIndex: filterIndex,
                tokenIndex: tokenIndex,
                address: address,
                coordinator: coordinator
            )
        )
    }

    func importKey(coordinator: WalletCoordinatable) {
        state.path.append(WalletContentLink.importKey(coordinator: coordinator))
    }
}
