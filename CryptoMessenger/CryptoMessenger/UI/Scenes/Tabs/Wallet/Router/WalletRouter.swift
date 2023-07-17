import SwiftUI

protocol WalletRouterable {
    func transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    )
    func transfer(wallet: WalletInfo, coordinator: WalletCoordinatable)
    func importKey(coordinator: WalletCoordinatable)
    func chooseReceiver(
        address: Binding<UserReceiverData>,
        coordinator: WalletCoordinatable
    )
    func popToRoot()
    func facilityApprove(
        transaction: FacilityApproveModel,
        coordinator: WalletCoordinatable
    )

    func showTransactionResult(model: TransactionResult)
}

struct WalletRouter<Content: View, State: WalletRouterStatable>: View {

    @ObservedObject var state: State

    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
                    .sheet(item: $state.presentedItem, content: sheetContent)
            }
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
        case let .transfer(wallet, coordinator):
            TransferConfigurator.build(wallet: wallet, coordinator: coordinator)
        case let .importKey(coordinator):
            ImportKeyConfigurator.build(coordinator: coordinator)
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

    func chooseReceiver(
        address: Binding<UserReceiverData>,
        coordinator: WalletCoordinatable
    ) {
        state.path.append(
            WalletContentLink.chooseReceiver(
                address: address,
                coordinator: coordinator
            )
        )
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
        state.coverItem = nil
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

    func transfer(wallet: WalletInfo, coordinator: WalletCoordinatable) {
        state.path.append(
            WalletContentLink.transfer(
                wallet: wallet,
                coordinator: coordinator
            )
        )
    }

    func importKey(coordinator: WalletCoordinatable) {
        state.path.append(WalletContentLink.importKey(coordinator: coordinator))
    }

    func facilityApprove(
        transaction: FacilityApproveModel,
        coordinator: WalletCoordinatable
    ) {
        state.path.append(
            WalletContentLink.facilityApprove(
                transaction: transaction,
                coordinator: coordinator
            )
        )
    }

    func showTransactionResult(model: TransactionResult) {
        state.presentedItem = WalletSheetLink.transactionResult(model: model)
    }
}
